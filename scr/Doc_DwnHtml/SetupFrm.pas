unit SetupFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,FileCtrl,TGetDocMgr,TCommon,
  Spin;

type
  TASetupFrm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Txt_SoundPort: TEdit;
    Txt_SoundServer: TEdit;
    Label8: TLabel;
    Label11: TLabel;
    Txt_DwnTxtErrCount: TEdit;
    Txt_DwnTitleErrCount: TEdit;
    Label12: TLabel;
    Bevel1: TBevel;
    Label13: TLabel;
    Bevel2: TBevel;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Txt_DwnTitleThreadCount: TEdit;
    Txt_DwnTxtThreadCount: TEdit;
    Bevel5: TBevel;
    Label10: TLabel;
    Bevel6: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Txt_DwnTodayTxtTime: TDateTimePicker;
    Txt_DwnHistoryTxtTime: TDateTimePicker;
    Chk_AutoDwnGet: TCheckBox;
    DwnMemo_RG: TRadioGroup;
    Label14: TLabel;
    Bevel3: TBevel;
    Label15: TLabel;
    Label7: TLabel;
    Txt_TR1DBPath: TEdit;
    Button1: TButton;
    Bevel4: TBevel;
    TabSheet2: TTabSheet;
    Label16: TLabel;
    Doc_Check_Time: TDateTimePicker;
    Label17: TLabel;
    Bevel7: TBevel;
    TabSheet6: TTabSheet;
    DateTimePicker_strat: TDateTimePicker;
    Label18: TLabel;
    Bevel8: TBevel;
    TabSheet7: TTabSheet;
    Label19: TLabel;
    Bevel9: TBevel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Bevel10: TBevel;
    Label23: TLabel;
    seTitleDwnTimeOut: TSpinEdit;
    seTextDwnTimeOut: TSpinEdit;
    seSleep: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
    FSaveOK : Boolean;
    FParam : TGetDocMgrParam;
    Procedure init();
    Function  CheckInput():Boolean;
    Function SaveToFile():Boolean;
  public
    { Public declarations }
    Function ShowWin(Param : TGetDocMgrParam):Boolean;
  end;

var
  ASetupFrm: TASetupFrm;

implementation

{$R *.dfm}

procedure TASetupFrm.Button1Click(Sender: TObject);
var
  S: string;
begin

  S := '';
  if SelectDirectory('路径', '', S) then
     Txt_Tr1DBPath.text := s;
  Self.Show;

end;

function TASetupFrm.CheckInput: Boolean;
begin

    Result := False;
    Txt_DwnTitleThreadCount.Text := Trim(Txt_DwnTitleThreadCount.Text);
    if Not IsInteger(PChar(Txt_DwnTitleThreadCount.Text)) Then
    Begin
        ShowMessage('请输入正确的数值(下载标题线程数目).');
        Exit;
    End;

    Txt_DwnTxtThreadCount.Text := Trim(Txt_DwnTxtThreadCount.Text);
    if Not IsInteger(PChar(Txt_DwnTxtThreadCount.Text)) Then
    Begin
        ShowMessage('请输入正确的数值(下载标题线程数目).');
        Exit;
    End;

    Txt_SoundPort.Text := Trim(Txt_SoundPort.Text);
    if Not IsInteger(PChar(Txt_SoundPort.Text)) Then
    Begin
        ShowMessage('请输入正确的数值(报警服务器端口).');
        Exit;
    End;

    Txt_DwnTitleErrCount.Text := Trim(Txt_DwnTitleErrCount.Text);
    if Not IsInteger(PChar(Txt_DwnTitleErrCount.Text)) Then
    Begin
        ShowMessage('请输入正确的数值(下载标题可发生错误的次数).');
        Exit;
    End;

    Txt_DwnTxtErrCount.Text := Trim(Txt_DwnTxtErrCount.Text);
    if Not IsInteger(PChar(Txt_DwnTxtErrCount.Text)) Then
    Begin
        ShowMessage('请输入正确的数值(下载文章可发生错误的次数).');
        Exit;
    End;

    Result := True;

end;

procedure TASetupFrm.init;
begin

   Txt_DwnTitleThreadCount.Text := IntToStr(FParam.DwnDocTitleThreadCount);
   Txt_DwnTxtThreadCount.Text   := IntToStr(FParam.DwnDocTxtThreadCount);

   Txt_DwnTodayTxtTime.Time     := FParam.DwnTodayDocStartTime;
   Txt_DwnHistoryTxtTime.Time   := FParam.DwnHistoryDocStartTime;
   Doc_Check_Time.Time  := FParam.Doc_Check_Time;

   Txt_TR1DBPath.Text := FParam.Tr1DBPath;

   Txt_SoundServer.Text := FParam.SoundServer;
   Txt_SoundPort.Text := IntToStr(FParam.SoundPort);
   Txt_DwnTitleErrCount.Text := IntTostr(FParam.DwnDocTitleErrCount);
   Txt_DwnTxtErrCount.Text := IntTostr(FParam.DwnDocTxtErrCount);
   DwnMemo_RG.ItemIndex  :=  FParam.DwnMemo;
   Chk_AutoDwnGet.Checked := FParam.AutoDwnGet;
   DateTimePicker_strat.DateTime:=StrToDate(Trim(FParam.StartGetDate)); //by leon 0808

   //wangjinhua 20110601
   seTitleDwnTimeOut.Value := FParam.DocTitleTimeOut;
   seTextDwnTimeOut.Value := FParam.DocTextTimeOut;
   seSleep.Value := FParam.DocSleep;
   //--

end;

function TASetupFrm.SaveToFile: Boolean;
begin

  Result := False;
  Try
  Try
     FParam.DwnDocTitleThreadCount := Round(StrToFloat(Txt_DwnTitleThreadCount.Text));
     FParam.DwnDocTxtThreadCount   := Round(StrToFloat(Txt_DwnTxtThreadCount.Text));
     FParam.DwnTodayDocStartTime   := StrToTime(FormatDateTime('hh:mm:ss',Txt_DwnTodayTxtTime.Time));
     FParam.DwnHistoryDocStartTime := StrToTime(FormatDateTime('hh:mm:ss',Txt_DwnHistoryTxtTime.Time));
     FParam.Doc_Check_Time  := StrToTime(FormatDateTime('hh:mm:ss',Doc_Check_Time.Time));
     FParam.Tr1DBPath  := Txt_TR1DBPath.Text;
     FParam.AutoDwnGet := Chk_AutoDwnGet.Checked;
     FParam.SoundServer := Txt_SoundServer.Text;
     FParam.SoundPort   := StrToInt(Txt_SoundPort.Text);
     FParam.DwnDocTitleErrCount := StrToInt(Txt_DwnTitleErrCount.Text);
     FParam.DwnDocTxtErrCount   := StrToInt(Txt_DwnTxtErrCount.Text);
     FParam.DwnMemo   := DwnMemo_RG.ItemIndex;

     if (FParam.StartGetDate)<> DateToStr(DateTimePicker_strat.DateTime) then
        DeleteFile(ExtractFilePath(Application.ExeName)+'ID_StartGetDate.lst');
     FParam.StartGetDate := DatetoStr(DateTimePicker_strat.DateTime);     //by leon 0808

     //wangjinhua 20110601
     FParam.DocTitleTimeOut := seTitleDwnTimeOut.Value ;
     FParam.DocTextTimeOut := seTextDwnTimeOut.Value;
     FParam.DocSleep := seSleep.Value ;
     //--

     FParam.SaveToFile;
     Result := True;
  Except
    On E:Exception Do
      ShowMessage(E.Message);
  End;
  Finally
  End;

end;

function TASetupFrm.ShowWin(Param : TGetDocMgrParam):Boolean;
begin

  FSaveOK := False;
  FParam  := Param;

  TabSheet1.Caption    := ConvertString('系统设定');
  Label9.Caption    := ConvertString('线程数量设定');
  Label1.Caption    := ConvertString('下载标题线程数目：');
  Label2.Caption    := ConvertString('下载文章线程数目：');
  Label10.Caption    := ConvertString('下载时间设定');
  Label3.Caption    := ConvertString('下载最新公告时间：');
  Label4.Caption    := ConvertString('检查历史缺漏时间：');

  TabSheet2.Caption    := ConvertString('完整性检查设定');
  Label17.Caption   := ConvertString('完整性检查设定    ');
  Label16.Caption   := ConvertString('公告完整性检查时间:  ');

  TabSheet4.Caption := ConvertString('下载网站');
  Label14.Caption    := ConvertString('下载网站选择     ');
  Label15.Caption    := ConvertString('(修改下载网站后请同时修改TR1DB的路径)     ');
  DwnMemo_RG.Items[0]:= ConvertString('大陆（中国证券网-F10）');
  DwnMemo_RG.Items[1]:= ConvertString('台湾（元大京華证券网-YuanTa）');

  TabSheet5.Caption := ConvertString('线程和下载时间');

  Chk_AutoDwnGet.Caption    := ConvertString('程序激活后直接进入下载模式');

  Label7.Caption    := ConvertString('Tr1DB路径：');
  OkBtn.Caption     := ConvertString('确定');
  CancelBtn.Caption := ConvertString('取消');

  TabSheet3.Caption := ConvertString('报警设定');
  Label12.Caption    := ConvertString('服务器设定');
  Label5.Caption    := ConvertString('报警服务器：');
  Label6.Caption    := ConvertString('报警服务器端口：');
  Label13.Caption    := ConvertString('当发生错误次数大于设定值时即报警');
  Label8.Caption    := ConvertString('下载标题可发生错误的次数：');
  Label11.Caption    := ConvertString('下载文章可发生错误的次数：');

  TabSheet6.Caption := ConvertString('下载的公告开始日期'); //by leon 0808
  Label18.Caption := ConvertString('下载的公告开始日期:');  //by leon 0808

  //wangjinhua 20110601
  TabSheet7.Caption := ConvertString('下载间隔时间和超时设置');
  Label23.Caption := ConvertString('下载超时设定');
  Label22.Caption := ConvertString('下载标题超时时间(秒)：');
  Label21.Caption := ConvertString('下载公告超时时间(秒)：');
  Label20.Caption := ConvertString('每轮下载完成后休息时间间隔');
  Label19.Caption := ConvertString('休眠时间(分钟)：');
  //--

  Caption := ConvertString('参数设定');
  init;

  ShowModal;

  Result := FSaveOK;


end;

procedure TASetupFrm.OKBtnClick(Sender: TObject);
begin
   if CheckInput Then
     if SaveToFile Then
     Begin
         FSaveOK := True;
         Close;
     End;
end;

procedure TASetupFrm.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

End.
