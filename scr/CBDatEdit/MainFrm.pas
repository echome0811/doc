//***************************************************************************
//1 procedure TCBStockHolderMgr.ReadDocDat(const ID: String);  修改逻辑
//2 ACBDateFrm 内的资金冻结日期的修改
//3 所有页面的搜索代码功能的修改。
//4 今日交易提示页面的界面修改以及响应函数的增加
//新增：
//1 procedure TAMainFrm.SpeedButton5Click(Sender: TObject); 增加符号修改
//2 function Comverb_SpecSymbol(TextStr: String): String;
////CBDatEdit-DOC3.0.0需求2-leon-08/8/18;(修改CBDatEdit的“停止转换期间”的代码在查找公告时的对应代码查找逻辑，将原本的直接删减，变成查询tr1db中的txt文件)
//--Doc3.2.0需求2 huangcq080926 修改bug:停止转换期间没有任何更改却仍然提示是否保存
//--DOC4.0.0—N002 huangcq081223 A)修改上传成功或者失败的提示  B)后台下载工具(交易提示、自营商进出 提示)
//--DOC4.0.0—N003 huangcq090209 add 转股价格调整 增加原因维护，保存index，命名为ResetLst.dat
//--Doc4.0 需求4 huangcq090317 add 赎回日期\卖回日期
//--Doc4.2.0-N006-sun-090610:增加台湾重要日期
//****************************************************************************


unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient,TDocMgr, Buttons, ToolWin,CBDocFrm,TCommon,
  CBPurposeFrm,CBStockHolderFrm,CBBaseInfoFrm,CBDateFrm,CBIdxFrm,CBStike2Frm,
  CBStrike3Frm,CBDealerFrm,CBStopConvFrm,CBIssueFrm,CBIssue2Frm,CBBondFrm,
  CsDef,ZLib,CBStopIssueDocFrm,CBTodayHintFrm,dxTL, dxCntner,
  MsnPopUp,CBDataLogFrm,SocketClientFrm,TSocketClasses,TZipCompress, CBDateTwFrm,
  CBRedeemDateFrm,CBSaleDateFrm, IdAntiFreezeBase, IdAntiFreeze,CBThreeTraderFrm,
  OpRecsQueryFrm,uUserMngFrm,TMsg, Menus,uLogInFrm,IniFiles,
  ShenBaoSetFrm;  //add by wangjinhua 20090626 Doc4.3

type
  //modify by wangjinhua ThreeTrader 091015
  //EnmAutoCheckOK=(CheckOK_ZZ,CheckOK_SZ,CheckOK_Dealer,CheckOK_Other);//--DOC4.0.0—N002 huangcq081223 add
  EnmAutoCheckOK=(CheckOK_ZZ,CheckOK_SZ,CheckOK_Dealer,CheckOK_ThreeTrader,CheckOK_Other);
  //--
  TAMainFrm = class(TForm)
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet_CBDoc: TTabSheet;
    TabSheet_CBIdx: TTabSheet;
    TabSheet_Strike2: TTabSheet;
    TabSheet_Strike3: TTabSheet;
    IdTCPClient1: TIdTCPClient;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Bevel5: TBevel;
    Panel2: TPanel;
    Label1: TLabel;
    Image2: TImage;
    SpeedButton2: TSpeedButton;
    Image1: TImage;
    Bevel2: TBevel;
    TabSheet_CBPurpose: TTabSheet;
    TabSheet_CbStockHolder: TTabSheet;
    TabSheet_CBBaseInfo: TTabSheet;
    TabSheet_CbDateInfo: TTabSheet;
    SpeedButton1: TSpeedButton;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    TabSheet_CBIssue2: TTabSheet;
    TabSheet_CBBond: TTabSheet;
    TabSheet_CBStopIssueDoc: TTabSheet;
    TabSheet_CBTodayHint: TTabSheet;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    TabSheet_cbdelear: TTabSheet;
    TabSheet_cbStopConv: TTabSheet;
    Edt_ID: TEdit;
    Btn_Sec: TButton;
    Image3: TImage;
    TimerSendLiveToDocCenter: TTimer;
    TabSheet_cbRedeemDate: TTabSheet;
    TabSheet_cbSaleDate: TTabSheet;
    TabSheet_CBLog: TTabSheet;
    TabSheet_cbThreeTrader: TTabSheet;
    mm1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    TabSheet_OpRecQuery: TTabSheet;
    TabSheet_ShenBaoSet: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure IdTCPClient1Status(axSender: TObject;
      const axStatus: TIdStatus; const asStatusText: String);
    procedure IdTCPClient1Work(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: Integer);
    procedure IdTCPClient1WorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: Integer);
    procedure IdTCPClient1WorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Btn_SecClick(Sender: TObject);
    procedure TimerSendLiveToDocCenterTimer(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
    ACBDocFrm : TACBDocFrm;
    ACBPurposeFrm : TACBPurposeFrm;
    ACBStockHolderFrm : TACBStockHolderFrm;
    ACBBaseInfoFrm : TACBBaseInfoFrm;
    ACBDateFrm : TACBDateFrm;
    ACBIdxFrm : TACBIdxFrm;
    ACBStike2Frm : TACBStike2Frm;
    ACBDealerFrm : TACBDealerFrm;
    ACBStopConvFrm : TACBStopConvFrm;
    ACBStrike3Frm : TACBStrike3Frm;
    ACBIssueFrm : TACBIssueFrm;
    ACBIssue2Frm : TACBIssue2Frm;
    ACBBondFrm : TACBBondFrm;
    ACBStopIssueDocFrm : TACBStopIssueDocFrm;
    ACBTodayHintFrm : TACBTodayHintFrm;
    AShenBaoSetFrm : TAShenBaoSetFrm;
    ACBRedeemDateFrm : TACBRedeemDateFrm;//--DOC4.0.0—N004 huangcq090317
    ACBSaleDateFrm : TACBSaleDateFrm;//--DOC4.0.0—N004 huangcq090317
    ACBDataLogFrm:TACBDataLogFrm;   //--DOC4.0.0—N002 huangcq081223 add-
    ASocketClientFrm : TASocketClientFrm; //--DOC4.0.0—N002 huangcq090617add
    ACBDateTWFrm : TACBDateTWFrm;//--Doc4.2.0-N006-sun-090610
    //add by wangjinhua ThreeTrader 091015
    ACBThreeTraderFrm : TACBThreeTraderFrm;
    FThreeTraderChecked:Byte;//0-今日尚未完成下载；1-今日完成下载但未提示；2-今日完成下载且已提示
    //--

    //add by wangjinhua 20090626 Doc4.3
    AOpRecsQueryFrm:TAOpRecsQueryFrm;
    AUserMngForm:TUserMngForm;
    //

    //--DOC4.0.0—N002 huangcq081223 add-------------------------->
    FStopRunning : Boolean;
    FDealerChecked:Byte;//0-今日尚未完成下载；1-今日完成下载但未提示；2-今日完成下载且已提示
    FHintChecked_ZZ:Byte;//同上
    FHintChecked_SZ:Byte;//同上
    procedure SetTodayIsAutoCheck(CheckOK_Type:EnmAutoCheckOK);
    procedure ShowHintFrm2();
    procedure ShowHintFrm();
    procedure Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);//--DOC4.0.0—N002 huangcq090407 add
    procedure SendDocCenterStatusMsg; //--DOC4.0.0—N002 huangcq090617 add
    //<--DOC4.0.0—N002 huangcq081223 add--------------------------

  public
    { Public declarations }
    FSearchID : string;
    FClassIndex : Integer;
    //add by wangjinhua 20090626 Doc4.3
    TrancsationRecs:TTrancsationRecs;
    FModouleList:_cStrLst;
//
    procedure SearchID(AMemo:TMemo);
    procedure ClearCBText();

    procedure SeekCBText(const SeekStr:String);
    function Comverb_SpecSymbol(TextStr: String): String;
    function SaveToFile(Const FileName:String;Const Memo:String):String;
    function  GetCBText(Reload:Boolean=false):Boolean;
    function  SetCBText():Boolean;
    Procedure CheckNotSaveCBText();
    procedure InitObj();
    procedure SetInitConnect();
    Function CompressOutPutFile(SourceText:String):String;
    Function CompressOutPutFile2(aFileName:String):String;
    Function  SaveCBText(DocTag:String;DocText:String):Boolean;
    Function  SaveCBText2(DocTag:String;aFileName:String):Boolean;
    Function ReadNewDoc(const ReadTag:String):String;
    Function ReadNewDoc2(const ReadTag:String;SavePath:String):String;  //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    Function ReadCBDataLog(const FileName:String):String;//--DOC4.0.0—N002 huangcq081223 add

    //add by wangjinhua 20090626 Doc4.3
    function InitAppUser(): Boolean;
    procedure CheckLogin(UserId,Psw:String;var LoginOk:Boolean);
    function GetModouleIndex(AModouleName:String;var AIndex:Integer):Boolean;
    procedure InitUser;
    procedure ScanfComponents(AContainer:TControl);
    procedure UnEnabledComponent(AComponent:TComponent);
    procedure dxTreeListEditing(Sender: TObject;Node: TdxTreeListNode; var Allow: Boolean);
    function CheckModouleList():Boolean;
    function GetUserList(var AUserLst : _CstrLst): Boolean;
    function GetUserListFromFile(AFile:String;var AUserLst : _CstrLst):Boolean;
    procedure GetModouleList(var AModouleList:_cStrLst);
    //--
  end;

var
  AMainFrm: TAMainFrm;

implementation



{$R *.dfm}

{ TAMainFrm }
//add by wangjinhua 20090626 Doc4.3

function TAMainFrm.CheckModouleList():Boolean;
var
  SResponse,vInfo: string;
  i: integer;
begin
  Result := False;
  vInfo := '';
  with PageControl1 do
  begin
    for i := 0 to PageCount - 1 do
    begin
      if Pages[i].TabVisible then
        if i=0 then
          vInfo := Pages[i].Caption
        else
          vInfo := vInfo + ',' + Pages[i].Caption;
    end;
  end;
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;
Try
Try
  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin
        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;
        WriteLn('UserMng');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 0 then Break;
        WriteLn('CheckModouleList');

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 1 then
        begin
          WriteLn(vInfo);
          SResponse := UpperCase(ReadLn);
            if Pos('HELLO', SResponse) = 1 then
              Result := True;
        end;
        Disconnect;
    end;
  end;
Except
end;
finally
   IdTCPClient1.Disconnect;
end;
end;


procedure TAMainFrm.GetModouleList(var AModouleList:_cStrLst);
var
  i:Integer;
begin
  SetLength(AModouleList,0);
  SetLength(AModouleList,PageControl1.PageCount);
  for i := 0 to PageControl1.PageCount-1 do
    AModouleList[i] := PageControl1.Pages[i].Caption;
end;

function TAMainFrm.GetUserListFromFile(AFile:String;var AUserLst : _CstrLst):Boolean;
var
  i: integer;
  ts:TStringList;
begin
try
try
  Result := false;
  SetLength(AUserLst,0);
  ts := TStringList.Create;
  ts.LoadFromFile(AFile);
  if (ts.Count mod 5 <> 0) then
    StatusBar1.Panels[2].Text := 'Recv Data Format Error'
  else begin
    i := 0;
    while i < ts.Count do
    begin
      SetLength(AUserLst,Length(AUserLst) + 1);
      AUserLst[High(AUserLst)]:= ts[i];
      i := i + 5;
    end;
    Result := true;
  end;
except
  on e:Exception do
  begin
    showmessage(e.Message);
    e := nil;
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


function TAMainFrm.GetUserList(var AUserLst : _CstrLst): Boolean;
var
  SResponse,vUserInfo: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count,i: integer;
  ts:TStringList;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;
  AStream := nil;
  Result := false;
Try
Try
  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin
        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;
        WriteLn('UserMng');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 0 then Break;
        WriteLn('RequestUserInfo');

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 1 then
        begin
          WriteLn('sa');
          SResponse := UpperCase(ReadLn);
          if Pos('HELLO', SResponse) = 0 then Break;

          AStream := TMemoryStream.Create();
          ReadStream(AStream, -1, True);
          AStream.Seek(0, soFromBeginning);
          AStream.ReadBuffer(count,sizeof(count));
          GetMem(Buffer, Count);

          decs := TDeCompressionStream.Create(AStream);
          decs.ReadBuffer(Buffer^, Count);

          AStream.Clear;
          AStream.WriteBuffer(Buffer^, Count);
          AStream.Position := 0;//复位流指针
          //AStream.LoadFromStream(decs);
          DstFile1 := GetWinTempPath + 'RequestUserInfo.dat';
          if FileExists(DstFile1) then
            DeleteFile(DstFile1);
          AStream.SaveToFile(DstFile1);

          if GetUserListFromFile(DstFile1,AUserLst) then
          begin
            StatusBar1.Panels[2].Text := 'RequestUserInfo Ok';
            Result := true;
          end;
        end
        else if Pos('FAIL', SResponse) = 1 then
          StatusBar1.Panels[2].Text := 'RequestUserInfo Failure';

        Disconnect;
    end;
  end;

Except
end;
finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;
end;

function TAMainFrm.InitAppUser(): Boolean;
var
  SResponse: string;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;
  Result := false;
Try
Try
  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin
        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;
        WriteLn('UserMng');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 0 then Break;
        WriteLn('InitUser');

          SResponse := UpperCase(ReadLn);
          if Pos('HELLO', SResponse) = 1 then
          begin
            StatusBar1.Panels[2].Text := 'InitUser Ok';
            Result := true;
          end
          else if Pos('FAIL', SResponse) = 1 then
            StatusBar1.Panels[2].Text := 'InitUser Failure';
          break;
    end;
  end;

Except
  on e:Exception do
    e := nil;
end;
finally
  try
   IdTCPClient1.Disconnect; 
  except
  end;
end;

end;


procedure TAMainFrm.CheckLogin(UserId,Psw:String; var LoginOk:Boolean);
var
  SResponse: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count,i: integer;
  ts:TStringList;
  vPurLst : _CstrLst;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;
  AStream := nil;
  LoginOk := false;
Try
Try
  with IdTCPClient1 do
  begin
    Connect;
    while Connected do
    begin
        SResponse := UpperCase(ReadLn);
        if Pos('CONNECTOK', SResponse) = 0 then Break;
        WriteLn('UserMng');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 0 then Break;
        WriteLn('CheckLogin');

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) = 1 then
        begin
          WriteLn(UserId + ',' + Psw);
          SResponse := UpperCase(ReadLn);
          if Pos('HELLO', SResponse) = 0 then Break;

            AStream := TMemoryStream.Create();
            ReadStream(AStream, -1, True);
            AStream.Seek(0, soFromBeginning);
            AStream.ReadBuffer(count,sizeof(count));
            GetMem(Buffer, Count);

            decs := TDeCompressionStream.Create(AStream);
            decs.ReadBuffer(Buffer^, Count);

            AStream.Clear;
            AStream.WriteBuffer(Buffer^, Count);
            AStream.Position := 0;//复位流指针
            //AStream.LoadFromStream(decs);
            DstFile1 := GetWinTempPath + 'CheckLogin.dat';
            DeleteFile(DstFile1);

            if FileExists(DstFile1) Then
               Exit;
            AStream.SaveToFile(DstFile1);
            //DeCompressFile(DstFile1,DstFile2);
            //Result := DstFile1;
            ts := TStringList.Create;
            ts.LoadFromFile(DstFile1);
            if ts.Count <> 5 then
              StatusBar1.Panels[2].Text := 'Recv Data Format Error'
            else begin
              P_CurUser.ID := ts[0];
              P_CurUser.Password := ts[1];
              for i := Low(P_CurUser.LookPurview) to High(P_CurUser.LookPurview) do
                P_CurUser.LookPurview[i] := false;
              for i := Low(P_CurUser.EditPurview) to High(P_CurUser.EditPurview) do
                P_CurUser.EditPurview[i] := false;

              SetLength(vPurLst,0);
              vPurLst := DoStrArray(ts[2],',');
              for i := Low(vPurLst) to High(vPurLst) do
                if vPurLst[i] = '1' then
                  P_CurUser.LookPurview[i] := true;

              SetLength(vPurLst,0);
              vPurLst := DoStrArray(ts[3],',');
              for i := Low(vPurLst) to High(vPurLst) do
                if vPurLst[i] = '1' then
                  P_CurUser.EditPurview[i] := true;

              P_CurUser.SuperUser := IntToBool( StrToInt(ts[4]) );
              if FileExists(DstFile1) then
                DeleteFile(DstFile1);
            end;

            StatusBar1.Panels[2].Text := 'CheckLogin Ok';
            LoginOk := true;
          end
          else if Pos('FAIL', SResponse) = 1 then
            StatusBar1.Panels[2].Text := 'CheckLogin Failure';

        //DeleteFile(DstFile2);
        Disconnect;
    end;
  end;
Except
end;
finally
   try
     if Assigned(ts) then
       FreeAndNil(ts);
   except
   end;
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;

end;


function TAMainFrm.GetModouleIndex(AModouleName:String;var AIndex:Integer):Boolean;
var
  i:Integer;
begin
  Result := false;
  AIndex := -1;

  with FAppParam do
  begin
    for i := 0 to UserMngModouleListCount - 1 do
      if UserMngModouleList[i] = AModouleName then
      begin
        AIndex := i;
        Result := true;
        break;
      end;
  end;
end;

procedure TAMainFrm.InitUser;
var
  i,vIndex:Integer;
  str:String;
begin
  //登陆
  if not InitAppUser then
  begin
    ShowMessage(FAppParam.ConvertString('初始化用户文件失败'));
    Application.Terminate;
  end;

  LogInForm := TLogInForm.Create(self);
  LogInForm.CheckLogin := CheckLogin;
  if LogInForm.ShowModal = mrCancel then
  begin
    Application.Terminate;
    halt;
  end;
  if Assigned(LogInForm) then
    LogInForm.Free;

  for i := 0 to PageControl1.PageCount - 1 do
    if PageControl1.Pages[i].TabVisible then
    begin
      if  GetModouleIndex(PageControl1.Pages[i].Caption,vIndex) then
        PageControl1.Pages[i].TabVisible := P_CurUser.LookPurview[vIndex]
      else begin
        PageControl1.Pages[i].TabVisible := false;
        //ShowMessage(FAppParam.ConvertString('模块列表配置错误!' + #13#10 + '请检查应用程序配置文件'));
        //Application.Terminate;
      end;
    end;

  if not P_CurUser.SuperUser then
    N2.Visible := false;

end;

procedure TAMainFrm.ScanfComponents(AContainer:TControl);
var
  i:Integer;
begin
  if AContainer is TForm then
  begin
    with (AContainer as TForm) do
    begin
      for i := 0 to ComponentCount - 1 do
        if Components[i] is TPanel then
          ScanfComponents(Components[i] as TPanel)
        else
          UnEnabledComponent(Components[i]);
    end;
  end
  else if AContainer is TFrame then
  begin
    with (AContainer as TFrame) do
    begin
      for i := 0 to ComponentCount - 1 do
        if Components[i] is TPanel then
          ScanfComponents(Components[i] as TPanel)
        else
          UnEnabledComponent(Components[i]);
    end;
  end
  else if AContainer is TPanel then
  begin
    with (AContainer as TPanel) do
    begin
      for i := 0 to ComponentCount - 1 do
        if Components[i] is TPanel then
          ScanfComponents(Components[i] as TPanel)
        else
          UnEnabledComponent(Components[i]);
    end;
  end;
end;

procedure TAMainFrm.UnEnabledComponent(AComponent:TComponent);
var
  j:Integer;
  i:Integer;
  str:string;
begin
    if (AComponent is TButton) then
    begin
      with (AComponent as TButton) do
      begin
        Enabled := not InRightList((AComponent as TButton).Caption);
      end;
    end
    else if (AComponent is TSpeedButton) then
    begin
      with (AComponent as TSpeedButton) do
      begin
        Enabled := not InRightList((AComponent as TSpeedButton).Caption);
      end;
    end
    else if (AComponent is TEdit) then
    begin
      with (AComponent as TEdit) do
      begin
        ReadOnly := InRightList((AComponent as TEdit).Name);
      end;
    end
    else if (AComponent is TMemo) then
      (AComponent as TMemo).ReadOnly := InRightList((AComponent as TMemo).Name)
    else if (AComponent is TRichEdit) then
      (AComponent as TRichEdit).ReadOnly := InRightList((AComponent as TRichEdit).Name)
    else if (AComponent is TdxTreeList) then
    begin
      (AComponent as TdxTreeList).OnEditing := dxTreeListEditing;
      with (AComponent as TdxTreeList) do
      begin
        if InRightList((AComponent as TdxTreeList).Name) then
          OnDblClick := nil;
      end;
    end;
end;


procedure TAMainFrm.dxTreeListEditing(Sender: TObject;Node: TdxTreeListNode; var Allow: Boolean);
begin
  Allow := false;
end;
//--



procedure TAMainFrm.InitObj;
begin
  FAppParam := TDocMgrParam.Create;
  //--DOC4.0.0—N002 huangcq081223 add ---------------------------->
  FStopRunning := False;

   FThreeTraderChecked:=0;//add by wangjinhua ThreeTrader 091015
   FDealerChecked:=0;
   FHintChecked_ZZ:=0;
   FHintChecked_SZ:=0;
   ASocketClientFrm := TASocketClientFrm.Create(Self,'CBDatEdit',FAppParam.DocServer
                                              ,FAppParam.DocCenterSktPort,Msg_ReceiveDataInfo);

   TimerSendLiveToDocCenter.Interval := 3000;
   TimerSendLiveToDocCenter.Enabled  := True;
  //<--DOC4.0.0—N002 huangcq081223 add----------------------------
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

function TAMainFrm.ReadNewDoc(const ReadTag: String): String;
var
  SResponse: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count: integer;
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

        WriteLn(ReadTag);

        AStream := TMemoryStream.Create();
        ReadStream(AStream, -1, True);
        AStream.Seek(0, soFromBeginning);
        AStream.ReadBuffer(count,sizeof(count));
        GetMem(Buffer, Count);

        decs := TDeCompressionStream.Create(AStream);
        decs.ReadBuffer(Buffer^, Count);

        AStream.Clear;
        AStream.WriteBuffer(Buffer^, Count);
        AStream.Position := 0;//复位流指针

        //AStream.LoadFromStream(decs);

        DstFile1 := GetWinTempPath+ReadTag;
        DeleteFile(DstFile1);

        if FileExists(DstFile1) Then
           Exit;
        //DstFile2 := GetWinTempPath+'_'+ReadTag;
        AStream.SaveToFile(DstFile1);
        //DeCompressFile(DstFile1,DstFile2);

        Result := DstFile1;

        //DeleteFile(DstFile2);

        Disconnect;

    end;
  end;

Except
end;

finally
   AMainFrm.IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;

end;


/////////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////////
function TAMainFrm.ReadNewDoc2(const ReadTag: String;SavePath:String): String;    //add by leon 080806
var
  SResponse: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count: integer;
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

        WriteLn(ReadTag);

        AStream := TMemoryStream.Create();
        ReadStream(AStream, -1, True);
        AStream.Seek(0, soFromBeginning);
        AStream.ReadBuffer(count,sizeof(count));
        GetMem(Buffer, Count);

        decs := TDeCompressionStream.Create(AStream);
        decs.ReadBuffer(Buffer^, Count);

        AStream.Clear;
        AStream.WriteBuffer(Buffer^, Count);
        AStream.Position := 0;//复位流指针

        //AStream.LoadFromStream(decs);

        DstFile1 := GetWinTempPath+SavePath+'\'+ReadTag;
        DeleteFile(DstFile1);

        if FileExists(DstFile1) Then
           Exit;
        //DstFile2 := GetWinTempPath+'_'+ReadTag;
        AStream.SaveToFile(DstFile1);
        //DeCompressFile(DstFile1,DstFile2);

        Result := DstFile1;

        //DeleteFile(DstFile2);

        Disconnect;

    end;
  end;

Except
end;

finally
   AMainFrm.IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;

end;

procedure TAMainFrm.SetInitConnect;
begin
  AMainFrm.IdTCPClient1.Port := 8090;
  AMainFrm.IdTCPClient1.Host := FAppParam.DocServer;
end;

procedure TAMainFrm.FormCreate(Sender: TObject);
var
  i:Integer;
begin
   ProgressBar1.Parent := StatusBar1;
   ProgressBar1.Top := 2;
   ProgressBar1.Left := 1;

   FSearchID   := '';
   FClassIndex := -1;
   if ParamCount>0 Then
   Begin
      FSearchID := ParamStr(1);
      FClassIndex := StrToInt(ParamStr(2));
   End;

   Case FClassIndex of
     1: PageControl1.ActivePage :=  TabSheet_Strike2;
     2: PageControl1.ActivePage :=  TabSheet_CBIdx;
   End;

   ClearCBText;
   InitObj;

   Label1.Caption := FAppParam.ConvertString('转债基本资料编辑工具程序');
   Label2.Caption := FAppParam.ConvertString('注意. 编辑资料后请执行保存或放弃');

   SpeedButton2.Caption := FAppParam.ConvertString('保存修改(&S)');
   SpeedButton1.Caption := FAppParam.ConvertString('放弃修改(&R)');
   SpeedButton3.Caption := FAppParam.ConvertString('退出工具(&E)');
   SpeedButton4.Caption := FAppParam.ConvertString('帮助文件(&H)');

   TabSheet_ShenBaoSet.Caption := FAppParam.ConvertString('申报公告设定');
   TabSheet_CBIdx.Caption := FAppParam.ConvertString('转股余额');
   TabSheet_Strike2.Caption := FAppParam.ConvertString('转股价格调整');
   TabSheet_Strike3.Caption := FAppParam.ConvertString('交易日数/上浮幅度');
   TabSheet_CBIssue2.Caption := FAppParam.ConvertString('网上/网下');
   TabSheet_CBDoc.Caption := FAppParam.ConvertString('条款原文');
   TabSheet_CBPurpose.Caption := FAppParam.ConvertString('募集资金用途');
   TabSheet_CbStockHolder.Caption := FAppParam.ConvertString('十大股东');
   TabSheet_CBBaseInfo.Caption := FAppParam.ConvertString('基本面资料');
   TabSheet_CbDateInfo.Caption := FAppParam.ConvertString('重要日期');
   TabSheet_CBBond.Caption := FAppParam.ConvertString('企业债');
   TabSheet_CBStopIssueDoc.Caption := FAppParam.ConvertString('停发公告设定');
   TabSheet_CBTodayHint.Caption := FAppParam.ConvertString('今日交易提示');
   TabSheet_cbdelear.Caption := FAppParam.ConvertString('自营商'); //modify by wangjinhua ThreeTrader 091015
   TabSheet_cbThreeTrader.Caption := FAppParam.ConvertString('三大法人');//add by wangjinhua ThreeTrader 091015
   TabSheet_cbStopConv.Caption := FAppParam.ConvertString('停止转换期间');
   TabSheet_cbRedeemDate.Caption := FAppParam.ConvertString('赎回日期');//--DOC4.0.0—N004 huangcq090317 add
   TabSheet_cbSaleDate.Caption := FAppParam.ConvertString('卖回日期');//--DOC4.0.0—N004 huangcq090317 add
   TabSheet_CBLog.Caption:=FAppParam.ConvertString('CB资料上传查看');//--DOC4.0.0—N002 huangcq081223 add
   Btn_Sec.Caption:= FAppParam.ConvertString('查询');

   Caption := FAppParam.ConvertString('转债基本资料编辑');

   //add by wangjinhua 20090602 Doc4.3
   TabSheet_OpRecQuery.Caption := FAppParam.ConvertString('操作记录查询');
   N1.Caption := FAppParam.ConvertString('主菜单(&M)');
   N2.Caption := FAppParam.ConvertString('用户帐户管理(&U)');
   N3.Caption := FAppParam.ConvertString('退出(&Q)');

    SetLength(FModouleList,0);
    for i := 0 to PageControl1.PageCount - 1 do
    begin
      if PageControl1.Pages[i].TabVisible then
      begin
        SetLength(FModouleList,Length(FModouleList)+1);
        FModouleList[High(FModouleList)] := PageControl1.Pages[i].Caption;
      end;
    end;

   if CheckModouleList() then
     FAppParam.Refresh
   else
     Application.Terminate;
   InitUser;
   //
   
   Timer1.Enabled := True;
   

end;

function TAMainFrm.GetCBText(Reload:Boolean=false): Boolean;
Var
  FileName1,FileName2,FileName3,filename4,cbtodayhintfilename,FileName5: String;
  inifile:Tinifile;
  FCharSet:String;
  vIndex:Integer;
  vModouleList,vUserList:_cStrLst;
Begin

  Result := false;
  SpeedButton5.Enabled:=false;
Try
Try
     if PageControl1.ActivePage=TabSheet_CBDoc Then
     Begin
       SpeedButton5.Enabled:=true;
         if Not Assigned(ACBDocFrm) Then
         Begin
            ACBDocFrm := TACBDocFrm.Create(Self);
            ACBDocFrm.SetInit(PageControl1.ActivePage,
               ReadNewDoc('CBDoc.dat'));
            //SaveToFile('CBDoc.dat',ReadNewDoc('CBDoc.dat')));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBDocFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
              UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDocFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
              ACBDocFrm.Refresh(ReadNewDoc('CBDoc.dat'));
            end;
            ACBDocFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CBPurpose Then
     Begin
       SpeedButton5.Enabled:=true;
         if Not Assigned(ACBPurposeFrm) Then
         Begin
            ACBPurposeFrm := TACBPurposeFrm.Create(Self);
            ACBPurposeFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBPurpose.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBPurposeFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBPurposeFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBPurposeFrm.Refresh(ReadNewDoc('CBPurpose.dat'));
            end;
            ACBPurposeFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CbStockHolder Then
     Begin
         SpeedButton5.Enabled:=true;
         if Not Assigned(ACBStockHolderFrm) Then
         Begin
            ACBStockHolderFrm := TACBStockHolderFrm.Create(Self);
            ACBStockHolderFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBStockHolder.dat'));
            //add by wangjinhua 20090626 Doc4.3
            ACBStockHolderFrm.FEditEnabled := true;
            ACBStockHolderFrm.Btn_RefreshClick(nil);
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
              begin
                ACBStockHolderFrm.FEditEnabled := false;
                ScanfComponents(ACBStockHolderFrm);
              end;
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStockHolderFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBStockHolderFrm.Refresh(ReadNewDoc('CBStockHolder.dat'));
            end;
            ACBStockHolderFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CbBaseInfo Then
     Begin
         if Not Assigned(ACBBaseInfoFrm) Then
         Begin
            ACBBaseInfoFrm := TACBBaseInfoFrm.Create(Self);
            ACBBaseInfoFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBBaseInfo.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
              begin
                ACBBaseInfoFrm.FEditEnabled := false;
                ACBBaseInfoFrm.Btn_MoveUp.Enabled := false;
                ACBBaseInfoFrm.Btn_MoveDwn.Enabled := false;
                ScanfComponents(ACBBaseInfoFrm);
              end;
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBBaseInfoFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBBaseInfoFrm.Refresh(ReadNewDoc('CBBaseInfo.dat'));
            end;
            ACBBaseInfoFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CbDateInfo Then
     Begin
        //***Doc4.2.0-N006-sun-090610**************************
       //台湾重要日期
       inifile := Tinifile.Create(ExtractFilePath(Application.ExeName)+'Setup.ini')  ;
       FCharSet :=inifile.ReadString('Config','Charset','GB2312_CHARSET');
       if FCharset='CHINESEBIG5_CHARSET' Then
       begin
         if Not Assigned(ACBDateTWFrm) Then
         Begin
            ACBDateTWFrm := TACBDateTwFrm.Create(Self);
            ACBDateTWFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('cbdatetw.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBDateTWFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
              UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDateTWFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
              ACBDateTWFrm.Refresh(ReadNewDoc('cbdatetw.dat'));
            end;
            ACBDateTWFrm.RefID;
         End;
         //*******************************************************************
       end else
       begin
         if Not Assigned(ACBDateFrm) Then
         Begin
            ACBDateFrm := TACBDateFrm.Create(Self);
            ACBDateFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBDate.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBDateFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDateFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBDateFrm.Refresh(ReadNewDoc('CBDate.dat'));
            end;
            ACBDateFrm.RefID;
         End;
       end;
     End;

     if PageControl1.ActivePage=TabSheet_CBIdx Then
     Begin
         if Not Assigned(ACBIdxFrm) Then
         Begin
            ACBIdxFrm := TACBIdxFrm.Create(Self);
            ACBIdxFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBIdx.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBIdxFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBIdxFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBIdxFrm.Refresh(ReadNewDoc('CBIdx.dat'));

            end;
            ACBIdxFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_Strike2 Then
     Begin
         if Not Assigned(ACBStike2Frm) Then
         Begin
            ACBStike2Frm := TACBStike2Frm.Create(Self);
            ACBStike2Frm.DownDBdata2;
            ACBStike2Frm.SetInit(PageControl1.ActivePage,
            //ReadNewDoc('Strike2.dat'));//--DOC4.0.0—N003 huangcq090209 del
            //ReadNewDoc('ResetLst.dat'));//--DOC4.0.0—N003 huangcq090209 add
            ReadNewDoc('strike4.dat')); //--DOC4.4.0.0  pqx 20120207
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBStike2Frm);
            //
         End Else
         Begin
            if Reload Then
            begin
              UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStike2Frm.Name,false);//add by wangjinhua 20090626 Doc4.3
              //ACBStike2Frm.Refresh(ReadNewDoc('ResetLst.dat'));//--DOC4.0.0—N003 huangcq090209 add
              ACBStike2Frm.Refresh(ReadNewDoc('strike4.dat')); //--DOC4.4.0.0   pqx 20120207
            end;
            ACBStike2Frm.RefID;
              //ACBStike2Frm.Refresh(ReadNewDoc('Strike2.dat'));//--DOC4.0.0—N003 huangcq090209 del
         End;
     End;


     //add by wangjinhua ThreeTrader 091015
     if PageControl1.ActivePage=TabSheet_cbthreetrader Then
     Begin
         if Not Assigned(ACBThreeTraderFrm) Then
         Begin
            ACBThreeTraderFrm := TACBThreeTraderFrm.Create(Self);
            ACBThreeTraderFrm.SetInit(PageControl1.ActivePage,ReadNewDoc('cbthreetrader@20060410.dat'),
                                   ReadNewDoc('threetraderlst.dat'),
                                   ReadNewDoc('stkIndex.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBThreeTraderFrm);
            //
         End Else
         Begin
            if Reload Then
              ACBThreeTraderFrm.Refresh(ReadNewDoc('cbthreetrader@20060410.dat'),
                                   ReadNewDoc('threetraderlst.dat'),
                                   ReadNewDoc('stkIndex.dat'));
         End;
     End;
     //--

     
     ///////////////////////////////////
     if PageControl1.ActivePage=TabSheet_cbdelear Then
     Begin
         if Not Assigned(ACBDealerFrm) Then
         Begin
            ACBDealerFrm := TACBDealerFrm.Create(Self);
            ACBDealerFrm.SetInit(PageControl1.ActivePage,'','','');
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBDealerFrm);
            //
         End Else
         Begin
            if Reload Then
              ACBDealerFrm.Refresh(ReadNewDoc('cbdealer@20060410.dat'),
                                   ReadNewDoc('cbdealerindex.dat'),
                                   ReadNewDoc('SecIndex.dat'));
         End;
     End;

     if PageControl1.ActivePage=TabSheet_cbStopConv Then
     Begin
         if Not Assigned(ACBStopConvFrm) Then
         Begin
            FileName1 := ReadNewDoc('cbstopconv.dat');
            FileName2 := '';//ReadNewDoc('doclst.dat');  modify by leon 080626
            ACBStopConvFrm := TACBStopConvFrm.Create(Self);
            ACBStopConvFrm.FFileLst:=ACBStopConvFrm.DownDBdata;  //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
            ACBStopConvFrm.SetInit(PageControl1.ActivePage,
              FileName1,FileName2);
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBStopConvFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStopConvFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBStopConvFrm.Refresh(ReadNewDoc('cbstopconv.dat'));

            end;
            ACBStopConvFrm.RefID;
         End;
     End;
     ////////////////////////////////////

     //--DOC4.0.0—N004 huangcq090317 add --->
     if PageControl1.ActivePage=TabSheet_cbRedeemDate Then
     Begin
        if Not Assigned(ACBRedeemDateFrm) then
        begin
           Screen.Cursor := crAppStart;
           FileName1 := ReadnewDoc('cbRedeemDate.dat');
           ACBRedeemDateFrm:=TACBRedeemDateFrm.Create(nil);
           FileName2 := ReadnewDoc('Trade_StockCode.Dat');
           ACBRedeemDateFrm.DownDBdata2;
           ACBRedeemDateFrm.SetInit(PageControl1.ActivePage,FileName1,FileName2);
           //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBRedeemDateFrm);
            //
           Screen.Cursor := crDefault;
        end else
        begin
           if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBRedeemDateFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBRedeemDateFrm.Refresh(ReadNewDoc('cbRedeemDate.dat'));

            end;
            ACBRedeemDateFrm.RefID;
        end;
     End;


     if PageControl1.ActivePage=TabSheet_cbSaleDate Then
     Begin
        if Not Assigned(ACBSaleDateFrm) then
        begin
           Screen.Cursor := crAppStart;
           FileName1 := ReadnewDoc('cbSaleDate.dat');
           ACBSaleDateFrm:=TACBSaleDateFrm.Create(nil);
           FileName2 := ReadnewDoc('Trade_StockCode.Dat');
           ACBSaleDateFrm.DownDBdata2;
           ACBSaleDateFrm.SetInit(PageControl1.ActivePage,FileName1,FileName2);
           //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBSaleDateFrm);
            //
           Screen.Cursor := crDefault;
        end else
        begin
           if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBSaleDateFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBSaleDateFrm.Refresh(ReadNewDoc('cbSaleDate.dat'));

            end;
            ACBSaleDateFrm.RefID;
        end;
     End;

     //<--DOC4.0.0—N004 huangcq090317 add--

     if PageControl1.ActivePage=TabSheet_Strike3 Then
     Begin
         if Not Assigned(ACBStrike3Frm) Then
         Begin
            ACBStrike3Frm := TACBStrike3Frm.Create(Self);
            ACBStrike3Frm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('Strike3.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBStrike3Frm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStrike3Frm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBStrike3Frm.Refresh(ReadNewDoc('Strike3.dat'));

            end;
            ACBStrike3Frm.RefID;
         End;
     End;


     if PageControl1.ActivePage=TabSheet_CBIssue2 Then
     Begin
         if Not Assigned(ACBIssue2Frm) Then
         Begin
            ACBIssue2Frm := TACBIssue2Frm.Create(Self);
            ACBIssue2Frm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('CBIssue2.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBIssue2Frm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBIssue2Frm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBIssue2Frm.Refresh(ReadNewDoc('CBIssue2.dat'));

            end;
            ACBIssue2Frm.RefID;
         End;
     End;


     if PageControl1.ActivePage=TabSheet_CBBond Then
     Begin
         if Not Assigned(ACBBondFrm) Then
         Begin
            ACBBondFrm := TACBBondFrm.Create(Self);
            ACBBondFrm.SetInit(PageControl1.ActivePage,
            ReadNewDoc('Bond.dat'));
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBBondFrm);
            //
         End Else
         Begin
            if Reload Then
            begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBBondFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               ACBBondFrm.Refresh(ReadNewDoc('Bond.dat'));

            end;
            ACBBondFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CBStopIssueDoc Then
     Begin
         if Not Assigned(ACBStopIssueDocFrm) Then
         Begin
            FileName1 := ReadNewDoc('stopissuedocidx.dat');
            FileName2 := '';// ReadNewDoc('doclst.dat');   modify by leon 080626
            FileName3 := ReadNewDoc('marketidlst.dat');
            ACBStopIssueDocFrm := TACBStopIssueDocFrm.Create(Self);
            ACBStopIssueDocFrm.SetInit(PageControl1.ActivePage,FileName1,FileName2,FileName3);
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBStopIssueDocFrm);
            //
         End Else
         Begin
            if Reload Then
            Begin
               UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStopIssueDocFrm.Name,false);//add by wangjinhua 20090626 Doc4.3
               FileName1 := ReadNewDoc('stopissuedocidx.dat');
               FileName2 := '';// ReadNewDoc('doclst.dat'); modify by leon 080626
               FileName3 := ReadNewDoc('marketidlst.dat');
               ACBStopIssueDocFrm.Refresh(FileName1,FileName2,FileName3);

            End;
            ACBStopIssueDocFrm.RefID;
         End;
     End;

     if PageControl1.ActivePage=TabSheet_CBTodayHint then
     Begin
         if Not Assigned(ACBTodayHintFrm) Then
         Begin
            FileName1 := ReadNewDoc('ZZ_cbtodayhint.dat');
            FileName2 := ReadNewDoc('ZZ_todayhintidlst.dat');
            FileName3 := ReadNewDoc('SZ_cbtodayhint.dat');
            FileName4 := ReadNewDoc('SZ_todayhintidlst.dat');
            cbtodayhintFilename := ReadNewDoc('cbtodayhint.dat');

            ACBTodayHintFrm := TACBTodayHintFrm.Create(Self);
            ACBTodayHintFrm.SetInit(PageControl1.ActivePage,
                                       FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
            //add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBTodayHintFrm);
            //
         End Else
         Begin
            if Reload Then
            Begin
              FileName1 := ReadNewDoc('ZZ_cbtodayhint.dat');
              FileName2 := ReadNewDoc('ZZ_todayhintidlst.dat');
              FileName3 := ReadNewDoc('SZ_cbtodayhint.dat');
              FileName4 := ReadNewDoc('SZ_todayhintidlst.dat');
              cbtodayhintFilename := ReadNewDoc('cbtodayhint.dat');

              ACBTodayHintFrm.Refresh(FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
            End;

         End;
     End;

     if PageControl1.ActivePage=TabSheet_ShenBaoSet then
     Begin
         if Not Assigned(AShenBaoSetFrm) Then
         Begin
            cbtodayhintFilename := ReadNewDoc('shenbaoset.dat');
            AShenBaoSetFrm := TAShenBaoSetFrm.Create(Self);
            AShenBaoSetFrm.SetInit(PageControl1.ActivePage,cbtodayhintFilename);
            {//add by wangjinhua 20090626 Doc4.3
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(ACBTodayHintFrm);
            //}
         End Else
         Begin
            if Reload Then
            Begin
              cbtodayhintFilename := ReadNewDoc('shenbaoset.dat');
              AShenBaoSetFrm.Refresh(cbtodayhintFilename);
            End;
         End;
     End;

     //--DOC4.0.0—N002 huangcq081223 add -->
     if PageControl1.ActivePage=TabSheet_CBLog then
     Begin
       if Not Assigned(ACBDataLogFrm) then
       begin
          ACBDataLogFrm:=TACBDataLogFrm.Create(self);
          ACBDataLogFrm.SetInit(PageControl1.ActivePage,ReadCBDataLog(FormatDateTime('yymmdd',Date)+'.log'));
       end else
       begin
          ACBDataLogFrm.RefreshLog();
       end;
     End;
     //<--DOC4.0.0—N002 huangcq081223 

     //add by wangjinhua 20090626 Doc4.3
     if PageControl1.ActivePage=TabSheet_OpRecQuery Then
     Begin
         if Not Assigned(AOpRecsQueryFrm) Then
         Begin
           //vModouleList,vUserList
            GetModouleList(vModouleList);
            GetUserList(vUserList);
            AOpRecsQueryFrm := TAOpRecsQueryFrm.Create(Self);
            AOpRecsQueryFrm.SetInit(PageControl1.ActivePage,vModouleList,vUserList);
            if GetModouleIndex(PageControl1.ActivePage.Caption,vIndex) then
              if not P_CurUser.EditPurview[vIndex] then
                ScanfComponents(AOpRecsQueryFrm); //add by wangjinhua 20090626 Doc4.2
            SetLength(vModouleList,0);
            SetLength(vUserList,0);
         End else
            AOpRecsQueryFrm.Show;
     End;
     //---
  Result := True;
Except
end;
finally
end;

end;

function TAMainFrm.SetCBText: Boolean;
Var
 Str : String;
begin

  Result := false;
  if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定保存文件修改结果? 一旦确定后资料将立即保存并上传!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
     Exit;

Try
Try
  if PageControl1.ActivePage=TabSheet_CBDoc Then
  Begin
     if Assigned(ACBDocFrm) Then
     Begin
       Str := ACBDocFrm.GetMemoText;
       ACBDocFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDocFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbdoc.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;

     End;
  End;

  if PageControl1.ActivePage=TabSheet_CBPurpose Then
  Begin
     if Assigned(ACBPurposeFrm) Then
     Begin
       Str := ACBPurposeFrm.GetMemoText;
       ACBPurposeFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBPurposeFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbpurpose.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;


  if PageControl1.ActivePage=TabSheet_CBStockHolder Then
  Begin
     if Assigned(ACBStockHolderFrm) Then
     Begin
       Str := ACBStockHolderFrm.GetMemoText;
       ACBStockHolderFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStockHolderFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbstockholder.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;


  if PageControl1.ActivePage=TabSheet_CBBaseInfo Then
  Begin
     if Assigned(ACBBaseInfoFrm) Then
     Begin
       Str := ACBBaseInfoFrm.GetMemoText;
       ACBBaseInfoFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBBaseInfoFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbbaseinfo.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_CBDateInfo Then
  Begin
     if Assigned(ACBDateFrm) Then
     Begin
       Str := ACBDateFrm.GetMemoText;
       ACBDateFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDateFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbdate.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
     if Assigned(ACBDateTWFrm) Then   //--Doc4.2.0-N006-sun-090610
     Begin
       Str := ACBDateTWFrm.GetMemoText;
       ACBDateTWFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBDateTWFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbdatetw.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;


  if PageControl1.ActivePage=TabSheet_CBIdx Then
  Begin
     if Assigned(ACBIdxFrm) Then
     Begin
       Str := ACBIdxFrm.GetMemoText;
       ACBIdxFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBIdxFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbidx.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_Strike2 Then
  Begin
     if Assigned(ACBStike2Frm) Then
     Begin
       Str := ACBStike2Frm.GetMemoText;
       ACBStike2Frm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStike2Frm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          //SaveCBText('ResetLst.dat',Str)  //--DOC4.0.0—N003 huangcq090209 add
          //SaveCBText('strike2.dat',Str)  //--DOC4.0.0—N003 huangcq090209 del
          SaveCBText('strike4.dat',Str) //--DOC4.4.0.0   pqx 20120207
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_Strike3 Then
  Begin
     if Assigned(ACBStrike3Frm) Then
     Begin
       Str := ACBStrike3Frm.GetMemoText;
       ACBStrike3Frm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStrike3Frm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('strike3.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;


  if PageControl1.ActivePage=TabSheet_CBIssue2 Then
  Begin
     if Assigned(ACBIssue2Frm) Then
     Begin
       Str := ACBIssue2Frm.GetMemoText;
       ACBIssue2Frm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBIssue2Frm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('cbissue2.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_CBBond Then
  Begin
     if Assigned(ACBBondFrm) Then
     Begin
       Str := ACBBondFrm.GetMemoText;
       ACBBondFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBBondFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('bond.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_CBStopIssueDoc Then
  Begin
     if Assigned(ACBStopIssueDocFrm) Then
     Begin
       Str := ACBStopIssueDocFrm.GetMemoText;
       ACBStopIssueDocFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStopIssueDocFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if Length(Str)>0 Then
          SaveCBText('stopissuedocidx.dat',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_CBTodayHint Then
  Begin
     if Assigned(ACBTodayHintFrm) Then
     Begin
       Str := ACBTodayHintFrm.GetMemoText;
       ACBTodayHintFrm.BeSave;
       if Length(Str)>0 Then
       begin
          SaveCBText('CBTODAYHINT.DAT',Str);
          SetTodayIsAutoCheck(CheckOK_ZZ);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add
          SetTodayIsAutoCheck(CheckOK_SZ);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add
       end
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  if PageControl1.ActivePage=TabSheet_ShenBaoSet Then
  Begin
     if Assigned(AShenBaoSetFrm) Then
     Begin
       Str := AShenBaoSetFrm.GetMemoText;
       AShenBaoSetFrm.BeSave;
       if Length(Str)>0 Then
       begin
          SaveCBText('shenbaoset.dat',Str);
       end
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;

  //////////////////////////////////////////////////////////////////////////////
  if PageControl1.ActivePage=TabSheet_CBDelear Then
  Begin
     if Assigned(ACBDealerFrm) Then
     Begin
       Str := ACBDealerFrm.GetFileName;
       if(Str<>'')then
       begin
         ACBDealerFrm.BeSave;
         if FileExists(Str) Then
         begin
            SaveCBText2('cbdealer@'+Copy(Str,Pos('[',Str)+1,Pos(']',Str)-Pos('[',Str)-1)+'.DAT',Str);
            if Abs(Date - ACBDealerFrm.DateSct.Date)<1 then  //是当前日期则执行此if动作
              SetTodayIsAutoCheck(CheckOK_Dealer);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add            
         end
         Else Begin
            ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
            Exit;
         End;
       end else Exit;
     End;
  End;


  //add by wangjinhua ThreeTrader 091015
  if PageControl1.ActivePage=TabSheet_CBThreeTrader Then
  Begin
     if Assigned(ACBThreeTraderFrm) Then
     Begin
       Str := ACBThreeTraderFrm.GetFileName;
       if(Str<>'')then
       begin
         ACBThreeTraderFrm.BeSave;
         if FileExists(Str) Then
         begin
            SaveCBText2('cbthreetrader@'+Copy(Str,Pos('[',Str)+1,Pos(']',Str)-Pos('[',Str)-1)+'.DAT',Str);
            if Abs(Date - ACBThreeTraderFrm.DateSct.Date)<1 then  //是当前日期则执行此if动作
              SetTodayIsAutoCheck(CheckOK_ThreeTrader);//保存了就预示着不用再在自动监测
         end
         Else Begin
            ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
            Exit;
         End;
       end else Exit;
     End;
  End;
  //--

  if PageControl1.ActivePage=TabSheet_cbStopConv Then
  Begin
     if Assigned(ACBStopConvFrm) Then
     Begin
       Str := ACBStopConvFrm.GetFileName;
       ACBStopConvFrm.BeSave;
       UptLogRecsFile(PageControl1.ActivePage.Caption,ACBStopConvFrm.Name);//add by wangjinhua 20090626 Doc4.3
       if FileExists(Str) Then
          SaveCBText2('CBSTOPCONV.DAT',Str)
       Else Begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
          Exit;
       End;
     End;
  End;
  //////////////////////////////////////////////////////////////////////////////

  //--DOC4.0.0—N004 huangcq090317 add --->
  if PageControl1.ActivePage=TabSheet_cbRedeemDate Then
  Begin
    if Assigned(ACBRedeemDateFrm) Then
    Begin
      Str:= ACBRedeemDateFrm.GetFileName;
      ACBRedeemDateFrm.BeSave;
      UptLogRecsFile(PageControl1.ActivePage.Caption,ACBRedeemDateFrm.Name);//add by wangjinhua 20090626 Doc4.3
      if FileExists(Str) then
        SaveCBText2('cbRedeemDate.dat',Str)
      else begin
        ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
        Exit;
      end;
    End;
  End;


  if PageControl1.ActivePage=TabSheet_cbSaleDate Then
  Begin
    if Assigned(ACBSaleDateFrm) Then
    Begin
      Str:= ACBSaleDateFrm.GetFileName;
      ACBSaleDateFrm.BeSave;
      UptLogRecsFile(PageControl1.ActivePage.Caption,ACBSaleDateFrm.Name);//add by wangjinhua 20090626 Doc4.3
      if FileExists(Str) then
        SaveCBText2('cbSaleDate.dat',Str)
      else begin
        ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
        Exit;
      end;
    End;
  End;

  //<--DOC4.0.0—N004 huangcq090317 add --  

  ShowMessage(FAppParam.ConvertString('保存完成!!'));

  Result := True;

Except
  On E:Exception do
    ShowMessage(E.Message);
end;
finally

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

procedure TAMainFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  try
    GetCBText;
  Except
    Timer1.Enabled := true;
  end;
end;

procedure TAMainFrm.ClearCBText;
begin
end;

procedure TAMainFrm.SearchID(AMemo: TMemo);
Var
 t1 : Integer;
begin

   t1 := Pos(FSearchID,AMemo.Text);
   if t1>0 Then
   Begin
     AMemo.SelStart := t1-1;
     AMemo.SelLength := Length(FSearchID);
     AMemo.SetFocus;
   End;


end;

function TAMainFrm.SaveCBText(DocTag, DocText: String): Boolean;
Var
  AStream: TFileStream;
  SResponse: string;
  ASaveError:Boolean;//--DOC4.0.0—N002 huangcq081223 add
begin

   SetInitConnect;
   AStream := nil;

   Result := False;

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
          DocText := CompressOutPutFile(DocText);
          if FileExists(DocText) Then
          Begin
            AStream := TFileStream.Create(DocText,fmOpenRead);
            OpenWriteBuffer;
            //WriteStream(AStream);  //--DOC4.0.0—N002 huangcq081223 del
            WriteStream(AStream,True,True);  //--DOC4.0.0—N002 huangcq081223 add
            CloseWriteBuffer;
          End;
          if Assigned(AStream) Then
             AStream.Free;
          AStream := nil;
          DeleteFile(DocText);
        End;

        //--DOC4.0.0—N002 huangcq081223 add--------->
          //服务器端多了一个如果保存成功，则WriteLn('SAVEOK'),如果没有保存成功则没有执行个写入语句,
          //客户端这里ReadLn若出现异常，则表示服务器端没有保存成功
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

Except
  On E:Exception do
     //ShowMessage(E.Message); //--DOC4.0.0—N002 huangcq081223 del
     Raise; //--DOC4.0.0—N002 huangcq081223 add
End;

Finally
   IdTCPClient1.Disconnect;
end;

end;

function TAMainFrm.SaveCBText2(DocTag, aFileName: String): Boolean;
Var
  AStream: TFileStream;
  SResponse: string;
  ASaveError:Boolean;//--DOC4.0.0—N002 huangcq081223 add
begin

   SetInitConnect;
   AStream := nil;

   Result := False;

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
          aFileName := CompressOutPutFile2(aFileName);
          if FileExists(aFileName) Then
          Begin
            AStream := TFileStream.Create(aFileName,fmOpenRead);
            OpenWriteBuffer;
            //WriteStream(AStream); //--DOC4.0.0—N002 huangcq081223 del
            WriteStream(AStream,True,True); //--DOC4.0.0—N002 huangcq081223 add
            CloseWriteBuffer;
          End;
          if Assigned(AStream) Then
             AStream.Free;
          AStream := nil;
          DeleteFile(aFileName);
        End;

        //--DOC4.0.0—N002 huangcq081223 add--------->
          //服务器端多了一个如果保存成功，则WriteLn('SAVEOK'),如果没有保存成功则没有执行个写入语句,
          //客户端这里ReadLn若出现异常，则表示服务器端没有保存成功
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

Except
  On E:Exception do
    // ShowMessage(E.Message); //--DOC4.0.0—N002 huangcq081223 del
    Raise; //--DOC4.0.0—N002 huangcq081223 add
End;

Finally
   IdTCPClient1.Disconnect;
end;

end;

procedure TAMainFrm.SpeedButton1Click(Sender: TObject);
begin
     //SetCBText;
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定放弃修改结果? 一旦确定后将遗失您辛苦编辑的资料,并将会重新加载文件资料!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   GetCBText(True);
end;

procedure TAMainFrm.PageControl1Change(Sender: TObject);
begin
  GetCBText;
end;

procedure TAMainFrm.SeekCBText(const SeekStr: String);
begin

Try
Try
     FSearchID := SeekStr;
Except
end;
finally
  FSearchID := '';
end;

end;



procedure TAMainFrm.SpeedButton2Click(Sender: TObject);
begin
  SetCBText;
end;

function TAMainFrm.SaveToFile(const FileName, Memo: String): String;
Var
  PathFileName : String;
  f : TStringList;
begin

  PathFileName := 'C:\Temp\'+FileName;
  Mkdir_Directory(ExtractFilePath(PathFileName));


  f := TStringList.Create;
  f.Text := Memo;
  f.SaveToFile(PathFileName);

  Result := PathFileName;


end;

procedure TAMainFrm.SpeedButton3Click(Sender: TObject);
begin
 Close;
end;

// Modified by wangjinhua 20090626 Doc4.3
procedure TAMainFrm.CheckNotSaveCBText;
Function AskSaveMsg(NeedSave:Boolean;Title:String):Boolean;
Begin

  Result := False;
  if NeedSave Then
  Begin
    if (IDYES=MessageBox(Self.Handle ,PChar(Title+FAppParam.ConvertString(' 已被修改但尚未保存,是否立即保存并上传?'))
                   ,PChar(FAppParam.ConvertString('确认')),MB_YESNO + MB_DEFBUTTON2+MB_ICONQUESTION)) then
       Result := True;
  End;

End;
Var
  Str : String;
begin
Try
Try
  if Assigned(ACBDocFrm) Then
  Begin
     if AskSaveMsg(ACBDocFrm.NeedSave,TabSheet_CBDoc.Caption) Then
     Begin
       Str := ACBDocFrm.GetMemoText;
       ACBDocFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbdoc.dat',Str);
       UptLogRecsFile(TabSheet_CBDoc.Caption,ACBDocFrm.Name);
     End else
       UptLogRecsFile(TabSheet_CBDoc.Caption,ACBDocFrm.Name,false);
  End;

  if Assigned(ACBPurposeFrm) Then
  Begin
     if AskSaveMsg(ACBPurposeFrm.NeedSave,TabSheet_CBPurpose.Caption) Then
     Begin
       Str := ACBPurposeFrm.GetMemoText;
       ACBPurposeFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbpurpose.dat',Str);
       UptLogRecsFile(TabSheet_CBPurpose.Caption,ACBPurposeFrm.Name);
     End else
       UptLogRecsFile(TabSheet_CBPurpose.Caption,ACBPurposeFrm.Name,false);
  End;

  if Assigned(ACBStockHolderFrm) Then
  Begin
    if AskSaveMsg(ACBStockHolderFrm.NeedSave,TabSheet_CBStockHolder.Caption) Then
    Begin
       Str := ACBStockHolderFrm.GetMemoText;
       ACBStockHolderFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbstockholder.dat',Str);
       UptLogRecsFile(TabSheet_CBStockHolder.Caption,ACBStockHolderFrm.Name);
    End else
       UptLogRecsFile(TabSheet_CBStockHolder.Caption,ACBStockHolderFrm.Name,false);
  End;


  if Assigned(ACBBaseInfoFrm) Then
  Begin
    if AskSaveMsg(ACBBaseInfoFrm.NeedSave,TabSheet_CBBaseInfo.Caption) Then
    Begin
       Str := ACBBaseInfoFrm.GetMemoText;
       ACBBaseInfoFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbbaseinfo.dat',Str);
       UptLogRecsFile(TabSheet_CBBaseInfo.Caption,ACBBaseInfoFrm.Name);
    End else
       UptLogRecsFile(TabSheet_CBBaseInfo.Caption,ACBBaseInfoFrm.Name,false);
  End;

  if Assigned(ACBDateFrm) Then
  Begin
    if AskSaveMsg(ACBDateFrm.NeedSave,TabSheet_CBDateInfo.Caption) Then
    Begin
       Str := ACBDateFrm.GetMemoText;
       ACBDateFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbdate.dat',Str);
       UptLogRecsFile(TabSheet_CBDateInfo.Caption,ACBDateFrm.Name);
    End else
       UptLogRecsFile(TabSheet_CBDateInfo.Caption,ACBDateFrm.Name,false);
  End;


  if Assigned(ACBIdxFrm) Then
  Begin
    if AskSaveMsg(ACBIdxFrm.NeedSave,TabSheet_CBIdx.Caption) Then
    Begin
       Str := ACBIdxFrm.GetMemoText;
       ACBIdxFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbidx.dat',Str);
       UptLogRecsFile(TabSheet_CBIdx.Caption,ACBIdxFrm.Name);
    End else
       UptLogRecsFile(TabSheet_CBIdx.Caption,ACBIdxFrm.Name,false);
  End;

  if Assigned(ACBStike2Frm) Then
  Begin
    if AskSaveMsg(ACBStike2Frm.NeedSave,TabSheet_Strike2.Caption) Then
    Begin
       Str := ACBStike2Frm.GetMemoText;
       ACBStike2Frm.BeSave;
       if Length(Str)>0 Then
          //SaveCBText('ResetLst.dat',Str); //--DOC4.0.0—N003 huangcq090209 add
          //SaveCBText('strike2.dat',Str); //--DOC4.0.0—N003 huangcq090209 del
          SaveCBText('strike4.dat',Str); //--DOC4.4.0.0   pqx 20120207
       UptLogRecsFile(TabSheet_Strike2.Caption,ACBStike2Frm.Name);
     End else
       UptLogRecsFile(TabSheet_Strike2.Caption,ACBStike2Frm.Name,false);
  End;

  if Assigned(ACBStrike3Frm) Then
  Begin
     if AskSaveMsg(ACBStrike3Frm.NeedSave,TabSheet_Strike3.Caption) Then
     Begin
       Str := ACBStrike3Frm.GetMemoText;
       ACBStrike3Frm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('strike3.dat',Str);
       UptLogRecsFile(TabSheet_Strike3.Caption,ACBStrike3Frm.Name);
     End else
       UptLogRecsFile(TabSheet_Strike3.Caption,ACBStrike3Frm.Name,false);
  End;

  if Assigned(ACBIssue2Frm) Then
  Begin
     if AskSaveMsg(ACBIssue2Frm.NeedSave,TabSheet_CBIssue2.Caption) Then
     Begin
       Str := ACBIssue2Frm.GetMemoText;
       ACBIssue2Frm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('cbissue2.dat',Str);
       UptLogRecsFile(TabSheet_CBIssue2.Caption,ACBIssue2Frm.Name);
     End else
       UptLogRecsFile(TabSheet_CBIssue2.Caption,ACBIssue2Frm.Name,false);
  End;

  if Assigned(ACBBondFrm) Then
  Begin
     if AskSaveMsg(ACBBondFrm.NeedSave,TabSheet_CBBond.Caption) Then
     Begin
       Str := ACBBondFrm.GetMemoText;
       ACBBondFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('bond.dat',Str);
       UptLogRecsFile(TabSheet_CBBond.Caption,ACBBondFrm.Name);
     End else
       UptLogRecsFile(TabSheet_CBBond.Caption,ACBBondFrm.Name,false);
  End;


  if Assigned(ACBStopIssueDocFrm) Then
  Begin
     if AskSaveMsg(ACBStopIssueDocFrm.NeedSave,TabSheet_CBStopIssueDoc.Caption) Then
     Begin
       Str := ACBStopIssueDocFrm.GetMemoText;
       ACBStopIssueDocFrm.BeSave;
       if Length(Str)>0 Then
          SaveCBText('stopissuedocidx.dat',Str);
       UptLogRecsFile(TabSheet_CBStopIssueDoc.Caption,ACBStopIssueDocFrm.Name);
     End else
       UptLogRecsFile(TabSheet_CBStopIssueDoc.Caption,ACBStopIssueDocFrm.Name,false);
  End;

  if Assigned(ACBTodayHintFrm) Then
  Begin
     if AskSaveMsg(ACBTodayHintFrm.NeedSave,TabSheet_CBTodayHint.Caption) Then
     Begin
       Str := ACBTodayHintFrm.GetMemoText;
       ACBTodayHintFrm.BeSave;
       if Length(Str)>0 Then
       begin
          SaveCBText('cbtodayhint.dat',Str);
          SetTodayIsAutoCheck(CheckOK_ZZ);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add
          SetTodayIsAutoCheck(CheckOK_SZ);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add
       end;
     End;
  End;

  if Assigned(AShenBaoSetFrm) Then
  Begin
     if AskSaveMsg(AShenBaoSetFrm.NeedSave,TabSheet_ShenBaoSet.Caption) Then
     Begin
       Str := AShenBaoSetFrm.GetMemoText;
       AShenBaoSetFrm.BeSave;
       if Length(Str)>0 Then
       begin
          SaveCBText('shenbaoset.dat',Str);
       end;
     End;
  End;

  ///////////////////////////////////
  if Assigned(ACBDealerFrm) Then
  Begin
     if AskSaveMsg(ACBDealerFrm.NeedSave,TabSheet_CBdelear.Caption) Then
     Begin
       if Assigned(ACBDealerFrm) Then
       Begin
         Str := ACBDealerFrm.GetFileName;
         ACBDealerFrm.BeSave;
         if FileExists(Str) Then
         begin
            //SaveCBText2('CBDEALER.DAT',Str); //--DOC4.0.0—N002 huangcq081223 del 这与正常的保存修改的操作不一样
            SaveCBText2('cbdealer@'+Copy(Str,Pos('[',Str)+1,Pos(']',Str)-Pos('[',Str)-1)+'.DAT',Str);
            if Abs(Date - ACBDealerFrm.DateSct.Date)<1 then  //是当前日期则执行此if动作
              SetTodayIsAutoCheck(CheckOK_Dealer);//保存了就预示着不用再在自动监测 --DOC4.0.0—N002 huangcq081223 add
         end
         Else Begin
            ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
            Exit;
         End;
       End;
     End;
  End;

  if Assigned(ACBStopConvFrm) Then
  Begin
     if AskSaveMsg(ACBStopConvFrm.NeedSave,TabSheet_CBStopConv.Caption) Then
     Begin
       if Assigned(ACBStopConvFrm) Then
       Begin
         Str := ACBStopConvFrm.GetFileName;
         ACBStopConvFrm.BeSave;
         if FileExists(Str) Then
            SaveCBText2('CBSTOPCONV.DAT',Str)
         Else Begin
            ShowMessage(FAppParam.ConvertString('无任何资料可上传.'));
            Exit;
         End;
       End;
       UptLogRecsFile(TabSheet_CBStopConv.Caption,ACBStopConvFrm.Name);
     End else
       UptLogRecsFile(TabSheet_CBStopConv.Caption,ACBStopConvFrm.Name,false);
  End;
  ////////////////////////////////////

  //--DOC4.0.0—N004 huangcq090317-->
  if Assigned(ACBRedeemDateFrm) Then
  Begin
    if AskSaveMsg(ACBRedeemDateFrm.NeedSave,TabSheet_cbRedeemDate.Caption) Then
    Begin
      if Assigned(ACBRedeemDateFrm) Then
      Begin
        Str :=ACBRedeemDateFrm.GetFileName;
        if FileExists(Str) Then
          SaveCBText2('CBREDEEMDATE.DAT',Str)
        else begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传'));
          Exit;
        end;
      End;
      UptLogRecsFile(TabSheet_cbRedeemDate.Caption,ACBRedeemDateFrm.Name);
    End else
       UptLogRecsFile(TabSheet_cbRedeemDate.Caption,ACBRedeemDateFrm.Name,false);
  End;


  if Assigned(ACBSaleDateFrm) Then
  Begin
    if AskSaveMsg(ACBSaleDateFrm.NeedSave,TabSheet_cbSaleDate.Caption) Then
    Begin
      if Assigned(ACBSaleDateFrm) Then
      Begin
        Str :=ACBSaleDateFrm.GetFileName;
        if FileExists(Str) Then
          SaveCBText2('CBSALEDATE.DAT',Str)
        else begin
          ShowMessage(FAppParam.ConvertString('无任何资料可上传'));
          Exit;
        end;
      End;
      UptLogRecsFile(TabSheet_cbSaleDate.Caption,ACBSaleDateFrm.Name);
    End else
       UptLogRecsFile(TabSheet_cbSaleDate.Caption,ACBSaleDateFrm.Name,false);
  End;

  //<--DOC4.0.0—N004 huangcq090317--


Except
  On E:Exception do
    ShowMessage(E.Message);
end;
finally

end;

end;
//--

procedure TAMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin

   if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确认退出工具!!'))
       ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Begin
     CheckNotSaveCBText;

     //--DOC4.0.0—N002 huangcq090407 add--->
     FStopRunning := True;
     TimerSendLiveToDocCenter.Interval := 1;
     While TimerSendLiveToDocCenter.Enabled  and
          (TimerSendLiveToDocCenter.Tag=1) Do
       Application.ProcessMessages;

     if ASocketClientFrm<>nil Then
     Begin
         ASocketClientFrm.ClearObj;
         ASocketClientFrm.Free;
         //ASocketClientFrm.Destroy;
         ASocketClientFrm:=nil;
     End;
     //<-----DOC4.0.0—N002 huangcq090407 add--

     Action := caFree;
   End Else
     Action := caNone;

end;

function TAMainFrm.CompressOutPutFile(SourceText: String): String;
Var
  DstFile : String;
  SourceFile : TStringList;

begin

  Result := '';
  SourceFile := nil;
Try
  if Length(SourceText)>0 Then
  Begin
    DstFile := GetWinTempPath+Get_GUID8+'.dat';
    SourceFile := TStringList.Create;
    SourceFile.Add(SourceText);
    SourceFile.SaveToFile(DstFile);
    CompressFile(DstFile,DstFile,clMax);
    Result := DstFile;
  End;
Finally
  if Assigned(SourceFile) Then
     SourceFile.Free;
End;

end;

function TAMainFrm.CompressOutPutFile2(aFileName: String): String;
Var
  DstFile : String;
begin

  Result := '';
Try
  if Length(aFileName)>0 Then
  Begin
    DstFile := GetWinTempPath+Get_GUID8+'.dat';
    CompressFile(DstFile,aFileName,clMax);
    Result := DstFile;
  End;
Finally
End;

end;

procedure TAMainFrm.SpeedButton4Click(Sender: TObject);
begin
  InvokeExe(ExtractFilePath(Application.ExeName)+'help.doc','');
end;


function TAMainFrm.Comverb_SpecSymbol(TextStr: String): String;
var S:string;
    i:integer;
    CheckLength:integer;
begin
Result:=TextStr;
try
  S:=TextStr;
  CheckLength:=length(S);
  if length(S)=0 then
     exit;
  while pos('',S)>0 do
  begin
    i:=pos('',S);
    S[i]:=' ';
  end;
  while pos('“',S)>0 do
  begin
    i:=pos('“',S);
    S[i]:=' ';
    S[i+1]:='"';
  end;
  while pos('”',S)>0 do
  begin
    i:=pos('”',S);
    S[i]:='"';
    S[i+1]:=' ';
  end;
  while pos('——',S)>0 do
  begin
    i:=pos('——',S);
    S[i]:='-';
    S[i+1]:=' ';
    S[i+2]:='-';
    S[i+3]:=' ';
  end;
  while pos('……',S)>0 do
  begin
    i:=pos('……',S);
    S[i]   := '.';
    S[i+1] := '.';
    S[i+2] := '.';
    S[i+3] := '.';
  end;
  while pos('—',S)>0 do
  begin
    i:=pos('—',S);
    S[i]:='-';
    S[i+1]:=' ';
  end;
  if CheckLength<>length(s) then
     exit;
  Result:=S;
except
end;
end;

procedure TAMainFrm.SpeedButton5Click(Sender: TObject);
Var
 AItem : TdxTreeListNode;
 i : Integer;
begin
  if PageControl1.ActivePage=TabSheet_CBDoc Then
  Begin
    ACBDocfrm.Txt_Memo.Lines.Text:=Comverb_SpecSymbol(ACBDocfrm.Txt_Memo.Lines.Text);
  End;

  if PageControl1.ActivePage=TabSheet_CBPurpose Then
  Begin
    ACBPurposeFrm.Txt_Memo.Lines.Text:=Comverb_SpecSymbol(ACBPurposeFrm.Txt_Memo.Lines.Text);
  end;

  //add by JoySun 2005/12/12 处理十大股东中的字符问题
  if PageControl1.ActivePage=TabSheet_CbStockHolder Then
  Begin
    For i:=0 to ACBStockHolderFrm.ListValue.Count-1 do
    Begin
     AItem :=  ACBStockHolderFrm.ListValue.Items[i];
     AItem.Strings[ACBStockHolderFrm.ListValue.ColumnByName('Column_A1').Index] :=
         Comverb_SpecSymbol(AItem.Strings[ACBStockHolderFrm.ListValue.ColumnByName('Column_A1').Index]);
    End;
    ACBStockHolderFrm.ListValue.Refresh;
  end;
end;


procedure TAMainFrm.Btn_SecClick(Sender: TObject);
begin
try
  F_SearchID:=Trim(Edt_ID.Text);
  GetCBText;
except

end;

end;

//--DOC4.0.0—N002 huangcq081223 add --------------------------------->
   //读取今日交易提示、自营商进出，并进行提醒
procedure TAMainFrm.ShowHintFrm2();
var
  Msner:TMSNPopUp;
  FileName1,FileName2,FileName3,filename4,cbtodayhintfilename: String;  
begin
  //TimerTodayHintAndDealer.Enabled:=False;
  if FStopRunning then exit;
  try
    Msner:=TMSNPopUp.Create(nil);  //self
    Msner.BackgroundImage:=image3.Picture.Bitmap;

    //今日交易提示信息自动获取      --其中一者今日还没搜寻到则需要搜寻
    if (FHintChecked_ZZ=1) or (FHintChecked_SZ=1) then
    begin
      FileName1 := ReadNewDoc('ZZ_cbtodayhint.dat');
      FileName2 := ReadNewDoc('ZZ_todayhintidlst.dat');
      FileName3 := ReadNewDoc('SZ_cbtodayhint.dat');
      FileName4 := ReadNewDoc('SZ_todayhintidlst.dat');
      cbtodayhintFilename := ReadNewDoc('cbtodayhint.dat');

         //可能存在 上证有今日交易提示信息而中证的没有
      if (Length(FileName1)<>0) and (Length(FileName2)<>0) and (FHintChecked_ZZ=1) then //Length为0表示没有取得内容。提示过就不再提示
      begin
        if Not Assigned(ACBTodayHintFrm) Then
        Begin
          ACBTodayHintFrm := TACBTodayHintFrm.Create(Self);
          ACBTodayHintFrm.SetInit(TabSheet_CBTodayHint,
                                     FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
        End Else
        Begin
          ACBTodayHintFrm.Refresh(FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
        End;

        SetTodayIsAutoCheck(CheckOK_ZZ);
        Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
        Msner.Text:=FAppParam.ConvertString('有中证今日交易提示信息!');
        Msner.ShowPopUp;
      end;//end zz

      if (Length(FileName3)<>0) and (Length(FileName4)<>0) and (FHintChecked_SZ=1) then //为0表示没有取得内容。提示过就不再提示
      begin
        if Not Assigned(ACBTodayHintFrm) Then
        Begin
          ACBTodayHintFrm := TACBTodayHintFrm.Create(Self);
          ACBTodayHintFrm.SetInit(TabSheet_CBTodayHint,
                                     FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
        End Else
        Begin
          ACBTodayHintFrm.Refresh(FileName1,FileName2,FileName3,FileName4,cbtodayhintFilename);
        End;

        SetTodayIsAutoCheck(CheckOK_SZ);
        Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
        Msner.Text:=FAppParam.ConvertString('有上证今日交易提示信息!');
        Msner.ShowPopUp;
      end; //end sz
    end;//END zz  sz

    //自营商进出信息自动获取         --今日尚未搜寻自营商进出信息且在doc_Dealer_tw.exe程序开始下载之后
    if (FDealerChecked=1) then
    begin
      FileName1 := ReadNewDoc('cbdealer@'+FormatDateTime('YYYYMMDD',Date)+'.dat');
      FileName2 := ReadNewDoc('cbdealerindex.dat');
      FileName3 := ReadNewDoc('SecIndex.dat');

      if ((Length(FileName1)<>0) and (Length(FileName2)<>0)) then
      begin
        if Not Assigned(ACBDealerFrm) Then
        Begin
          ACBDealerFrm := TACBDealerFrm.Create(Self);
          ACBDealerFrm.SetInit(TabSheet_cbdelear,'','','');
        End;
        //自营商进出如果当前有内容则不加载
        if not (ACBDealerFrm.ListValue.Count >0) then
          ACBDealerFrm.Refresh(FileName1,FileName2,FileName3);

        SetTodayIsAutoCheck(CheckOK_Dealer);
        Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
        Msner.Text:=FAppParam.ConvertString('有本日自营商进出信息!');
        Msner.ShowPopUp;
      end;
    end; //end  FDealerChecked
  finally
    if Assigned(Msner) then
    begin
      Msner.Destroy;
    end;
  end;
end;
procedure TAMainFrm.ShowHintFrm();
var
  Msner:TMSNPopUp;
begin
  //TimerTodayHintAndDealer.Enabled:=False;
  if FStopRunning then exit;
  try
    //Msner:=TMSNPopUp.Create(self);  //self
    Msner:=TMSNPopUp.Create(nil);
    Msner.BackgroundImage:=image3.Picture.Bitmap;

    if (FHintChecked_ZZ=1) then
    begin
      SetTodayIsAutoCheck(CheckOK_ZZ);
      Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
      Msner.Text:=FAppParam.ConvertString('有中证今日交易提示信息!');
      Msner.ShowPopUp;
    end;

    if (FHintChecked_SZ=1) then
    begin
      SetTodayIsAutoCheck(CheckOK_SZ);
      Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
      Msner.Text:=FAppParam.ConvertString('有上证今日交易提示信息!');
      Msner.ShowPopUp;
    end;

    //自营商进出信息自动获取         --今日尚未搜寻自营商进出信息且在doc_Dealer_tw.exe程序开始下载之后
    if (FDealerChecked=1) then
    begin
      SetTodayIsAutoCheck(CheckOK_Dealer);
      Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
      Msner.Text:=FAppParam.ConvertString('有本日自营商进出信息!');
      Msner.ShowPopUp;
      {if PageControl1.ActivePage <> TabSheet_cbdelear then
        PageControl1.ActivePage := TabSheet_cbdelear;
      GetCBText(True);}
    end; //end  FDealerChecked

    //add by wangjinhua ThreeTrader 091015
    //三大法人进出信息自动获取    --今日尚未搜寻三大法人进出信息且在doc_ThreeTrader_tw.exe程序开始下载之后
    if (FThreeTraderChecked=1) then
    begin
      SetTodayIsAutoCheck(CheckOK_ThreeTrader);
      Msner.Title:=FAppParam.ConvertString('CBDatEdit提示');
      Msner.Text:=FAppParam.ConvertString('有本日三大法人进出信息!');
      Msner.ShowPopUp;
      {if PageControl1.ActivePage <> TabSheet_cbThreeTrader then
        PageControl1.ActivePage := TabSheet_cbThreeTrader;
      GetCBText(True);}
    end;
    //--
  finally
    if Assigned(Msner) then
    begin
      Msner.Destroy;
    end;
  end;
end;

procedure TAMainFrm.SetTodayIsAutoCheck(CheckOK_Type:EnmAutoCheckOK);
begin
  try
    Case CheckOK_Type of
      CheckOK_ZZ: begin
        FHintChecked_ZZ:=2;
      end; //end zz

      CheckOK_SZ: begin
        FHintChecked_SZ:=2;
      end; //end sz

      CheckOK_Dealer: Begin
        FDealerChecked:=2;
      end; //end dealer

      //add by wangjinhua ThreeTrader 091015
      CheckOK_ThreeTrader: Begin
        FThreeTraderChecked:=2;
      end; //end threetrader
      //--
      
      CheckOK_Other: Begin
      end; //end other
    end; //end case
  finally
  end;
end;

procedure TAMainFrm.TimerSendLiveToDocCenterTimer(Sender: TObject);
begin
  if TimerSendLiveToDocCenter.Tag=1 Then
     exit;
  TimerSendLiveToDocCenter.Tag :=1;
  Try
    if FStopRunning then exit;
    if ASocketClientFrm<>nil Then
       SendDocCenterStatusMsg();

  Finally
    if FStopRunning then TimerSendLiveToDocCenter.Enabled := False;
    TimerSendLiveToDocCenter.Tag :=0;
  end;
end;

procedure TAMainFrm.SendDocCenterStatusMsg;
begin

  if ASocketClientFrm<>nil Then  //发送包括是否完成本日下载的信息 (不在WarningCenter上显示)
  Begin
     ASocketClientFrm.SendText('SendTo=DocCenter;'+
                                'Message=CBDatEdit;'
                                );
    //Memo1.Lines.Add(FormatDateTime('hh:mm:ss',Now)+'SendLiveToDocCenter');
  End;
end;

procedure TAMainFrm.Msg_ReceiveDataInfo(ObjWM: PWMReceiveString);
Var
  WMString: PWMReceiveString;
  Value,Value2 : String;
begin
  if FStopRunning then exit;
  Try
    WMString :=  ObjWM;
    if WMString.WMType='DOCPACKAGE' Then  //RCCPackage
    Begin
      Value := GetReceiveStrColumnValue('Message',WMString.WMReceiveString);
      if Length(Value)>0 Then
      Begin
         if Value='Doc_ChinaTodayHint_SZ' then
         Begin
            Value2:=GetReceiveStrColumnValue('DownLoadSZHintData',WMString.WMReceiveString);
            if (StrToBool(Value2)) then
            begin
              if (FHintChecked_SZ <>2) then  //if had showhintfrm, nerver show again
              begin
                FHintChecked_SZ:=1;
                ShowHintFrm;
              end;
            end;
         End;
         if Value='Doc_ChinaTodayHint_ZZ' then
         Begin
            Value2:=GetReceiveStrColumnValue('DownLoadZZHintData',WMString.WMReceiveString);
            if (StrToBool(Value2)) then
            begin
              if (FHintChecked_ZZ <>2) then
              begin
                FHintChecked_ZZ:=1;
                ShowHintFrm;
              end;
            end;
         End;
         if Value='Doc_Dealer_TW' then
         Begin
            Value2:=GetReceiveStrColumnValue('DownLoadTWDealerData',WMString.WMReceiveString);
            if (StrToBool(Value2)) then
            begin
              if (FDealerChecked <>2) then
              begin
                FDealerChecked:=1;
                ShowHintFrm;
              end;
            end;
         End;

         //add by wangjinhua ThreeTrader 091015
         if Value='Doc_ThreeTrader_TW' then
         Begin
            Value2:=GetReceiveStrColumnValue('DownLoadTWThreeTraderData',WMString.WMReceiveString);
            if (StrToBool(Value2)) then
            begin
              if (FThreeTraderChecked <>2) then
              begin
                FThreeTraderChecked:=1;
                ShowHintFrm;
              end;
            end;
         End;
         //--
      End;

      Value2 := GetReceiveStrColumnValue('Broadcast',WMString.WMReceiveString);
      if Length(Value2)>0 Then
      Begin
        //if Value2='CloseSystem' Then
        //  application.Terminate;

      End;
    End;
  except
  end;
end;

//<--DOC4.0.0—N002 huangcq081223 add ---------------------------------

//add by wangjinhua 20090626 Doc4.3
procedure TAMainFrm.N2Click(Sender: TObject);
var
  vModouleList:_cStrLst;
  i,j,iCount:Integer;
  str:String;
begin
  if not Assigned(AUserMngForm) then
  begin
    AUserMngForm := TUserMngForm.Create(nil);
    SetLength(vModouleList,0);
    for i := 0 to PageControl1.PageCount - 1 do
    begin
       SetLength(vModouleList,Length(vModouleList)+1);
       vModouleList[High(vModouleList)] := PageControl1.Pages[i].Caption;
    end;

    AUserMngForm.InitModouleList(vModouleList);
    SetLength(vModouleList,0);
  end;
  AUserMngForm.ShowModal;
end;

procedure TAMainFrm.N3Click(Sender: TObject);
begin
  SendMessage(Self.Handle,WM_CLOSE,0,0);
end;
//--

end.
