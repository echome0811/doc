unit CBThreeTraderFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, dxTL, dxCntner,TDocMgr,TDocRW,TCommon,
  Buttons,ZLib, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,DateUtils,
  dxDBCtrl, dxDBGrid, dxTLClms,IniFiles;

type
  TACBThreeTraderFrm = class(TFrame)
    Splitter1: TSplitter;
    Panel_Top: TPanel;
    Panel_Body: TPanel;
    PageCtl: TPageControl;
    TabSheet1: TTabSheet;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_SecID: TdxTreeListColumn;
    Column_SecName: TdxTreeListColumn;
    Column_ForeignBuy: TdxTreeListColumn;
    Column_ForeignNet: TdxTreeListColumn;
    Column_InvestBuy: TdxTreeListColumn;
    Column_InvestSale: TdxTreeListColumn;
    Column_InvestNet: TdxTreeListColumn;
    TabSheet3: TTabSheet;
    Panel1: TPanel;
    DateSct: TDateTimePicker;
    Btn_Apply: TBitBtn;
    IdTCPClient1: TIdTCPClient;
    Panel2: TPanel;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    DateGet: TMonthCalendar;
    GroupBox2: TGroupBox;
    Edt_Date: TEdit;
    Btn_Get: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Column_ForeignSale: TdxTreeListPickColumn;
    Timer_CheckModify: TTimer;
    Lbl_Caption: TLabel;
    Column_DealerBuy: TdxTreeListColumn;
    Column_DealerSale: TdxTreeListColumn;
    Column_DealerNet: TdxTreeListColumn;
    Column_ThreeTraderCount: TdxTreeListColumn;
    procedure Btn_ApplyClick(Sender: TObject);
    procedure Btn_GetClick(Sender: TObject);
    procedure DateGetClick(Sender: TObject);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
  private
    { Private declarations }
    FNeedSaveUpload : Boolean;
    FHaveChangeData : Boolean;
    beChanged:Boolean;
    RequestDate:TDate;
    FNode : TdxTreeListNode;
    FStkIndexFileName:String;
    procedure init(AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName:String);
    Function GetSecName(aFileName,aSecID :String):String;
    function ReadNewDoc(const ReadTag: String): String;
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;const AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName: String);
    Procedure Refresh(const AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName: String);
    Function  GetFileName():String;
    procedure BeSave();
    function  NeedSave:Boolean;
  end;
implementation

{$R *.dfm}

{ TACBDealerFrm }

procedure TACBThreeTraderFrm.BeSave;
begin
  FNeedSaveUpload := False;
end;

function TACBThreeTraderFrm.NeedSave: Boolean;
begin
  Result := FNeedSaveUpload ;
end;

procedure TACBThreeTraderFrm.Refresh(
  const AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName: String);
begin
    init(AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName);
end;

procedure TACBThreeTraderFrm.SetInit(Parent: TWinControl;
  const AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName: String);
begin
  Self.Parent := Parent;
  Self.Align := alClient;

  Lbl_Caption.Caption :=FappParam.ConvertString('转换公司债三大法人进出个股明细表数据            ');
  ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
  ListValue.Columns[1].Caption := FAppParam.ConvertString('转债代码');
  ListValue.Columns[2].Caption := FAppParam.ConvertString('转债名称');
  ListValue.Columns[3].Caption := FAppParam.ConvertString('外资及陆资买');
  ListValue.Columns[4].Caption := FAppParam.ConvertString('外资及陆资卖');
  ListValue.Columns[5].Caption := FAppParam.ConvertString('外资及陆资净买');
  ListValue.Columns[6].Caption := FAppParam.ConvertString('投信买进股数');
  ListValue.Columns[7].Caption := FAppParam.ConvertString('投信卖股数');
  ListValue.Columns[8].Caption := FAppParam.ConvertString('投信净买股数');
  ListValue.Columns[9].Caption := FAppParam.ConvertString('自营商买股数');
  ListValue.Columns[10].Caption := FAppParam.ConvertString('自营商卖股数');
  ListValue.Columns[11].Caption := FAppParam.ConvertString('自营商净买股数');
  ListValue.Columns[12].Caption := FAppParam.ConvertString('三大法人买卖超股数');
  Btn_Apply.Caption := FAppParam.ConvertString('刷新');
  Tabsheet1.Caption := FAppParam.ConvertString('资料审核');
  TabSheet3.Caption := FAppParam.ConvertString('资料回补');
  Label1.Caption := FAppParam.ConvertString('当前选择的日期为            ');
  Label2.Caption := FAppParam.ConvertString('历史资料回补              ');

  Btn_Get.Caption := FAppParam.ConvertString('回补资料');
  Edt_Date.Text:=FormatDateTime('YYYY-MM-DD',DateGet.Date);
  DateSct.Date:=Date;
  DateGet.Date:=Date;
  //init(AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName);
end;

procedure TACBThreeTraderFrm.init(AcbThreeTraderFilename,AcbThreeTraderIndexFileName,AStkIndexFileName:String);
Var
  AItem : TdxTreeListNode;
  RecLst :TDAILY_THREETRADER_RPTS;
  i:integer;
begin
  beChanged:=false;
  FNeedSaveUpload := false;
  FStkIndexFileName:=AStkIndexFileName;

  GetSecThreeTrader(PChar(AcbThreeTraderFilename),RecLst);
  ListValue.ClearNodes;

  For i:=Low(RecLst) To High(RecLst) Do
  Begin
    AItem :=  ListValue.Add;
    AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
    AItem.Strings[ListValue.ColumnByName('Column_SecID').Index] :=RecLst[i].SEC_ID;
    //showMessage(RecLst[i].SEC_ID + #13#10 + IntToStr(Length(RecLst[i].SEC_ID)));
    //AItem.Strings[ListValue.ColumnByName('Column_SecName').Index] := GetSecName(AStkIndexFileName,RecLst[i].SEC_ID);
    AItem.Strings[ListValue.ColumnByName('Column_ForeignBuy').Index] :=IntToStr(RecLst[i].FOREIGN_BUY);
    AItem.Strings[ListValue.ColumnByName('Column_ForeignSale').Index] :=IntToStr(RecLst[i].FOREIGN_SALE);
    AItem.Strings[ListValue.ColumnByName('Column_ForeignNet').Index] :=IntToStr(RecLst[i].FOREIGN_NET);
    AItem.Strings[ListValue.ColumnByName('Column_InvestBuy').Index] :=IntToStr(RecLst[i].INVEST_BUY);
    AItem.Strings[ListValue.ColumnByName('Column_InvestSale').Index] :=IntToStr(RecLst[i].INVEST_SALE);
    AItem.Strings[ListValue.ColumnByName('Column_InvestNet').Index] :=IntToStr(RecLst[i].INVEST_NET);
    AItem.Strings[ListValue.ColumnByName('Column_DealerBuy').Index] :=IntToStr(RecLst[i].DEALER_BUY);
    AItem.Strings[ListValue.ColumnByName('Column_DealerSale').Index] :=IntToStr(RecLst[i].DEALER_SALE);
    AItem.Strings[ListValue.ColumnByName('Column_DealerNet').Index] :=IntToStr(RecLst[i].DEALER_NET);
    AItem.Strings[ListValue.ColumnByName('Column_ThreeTraderCount').Index] :=IntToStr(RecLst[i].THREETRADER_COUTN);
  End;
end;


Function TACBThreeTraderFrm.GetSecName(aFileName,aSecID :String):String;
Var
  fIni:TIniFile;
  i:Integer;
Begin
  Result :='NONE';
try
  fIni := TIniFile.Create(aFileName);
  Result := fIni.ReadString(aSecID,'name','NONE');
except
  on e:Exception do
  begin
    ShowMessage(e.Message);
    e := nil;
  end;
end;
  try
    if Assigned(fIni)then
      FreeAndNil(fIni);
  except
    on e:Exception do
      e := nil;
  end;
End;



function TACBThreeTraderFrm.GetFileName: String;
var
  AItem : TdxTreeListNode;
  RecLst :TDAILY_THREETRADER_RPTS;
  i:integer;
  FileName :String;
  haveNone:Boolean;
begin
  Result :='';
  havenone :=false;
try
  if(ListValue.Count=0)then exit;
  SetLength(RecLst,0);
  For i:=0 to ListValue.Count-1 do
  Begin
    AItem :=  ListValue.Items[i];
    SetLength(RecLst,Length(RecLst)+1);

    if(Trim(AItem.Strings[ListValue.ColumnByName('Column_SecID').Index])='NONE')then
      HaveNone:=true;
    RecLst[High(RecLst)].SEC_ID            :=Trim(AItem.Strings[ListValue.ColumnByName('Column_SecID').Index]);
    RecLst[High(RecLst)].FOREIGN_BUY       :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_ForeignBuy').Index]));
    RecLst[High(RecLst)].FOREIGN_SALE      :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_ForeignSale').Index]));
    RecLst[High(RecLst)].FOREIGN_NET       :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_ForeignNet').Index]));
    RecLst[High(RecLst)].INVEST_BUY        :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_InvestBuy').Index]));
    RecLst[High(RecLst)].INVEST_SALE       :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_InvestSale').Index]));
    RecLst[High(RecLst)].INVEST_NET        :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_InvestNet').Index]));
    RecLst[High(RecLst)].DEALER_BUY        :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_DealerBuy').Index]));
    RecLst[High(RecLst)].DEALER_SALE       :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_DealerSale').Index]));
    RecLst[High(RecLst)].DEALER_NET        :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_DealerNet').Index]));
    RecLst[High(RecLst)].THREETRADER_COUTN :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_ThreeTraderCount').Index]));
  End;
  if(HaveNone)then
  begin
    if (IDOK<>MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('该天的三大法人资料中包含NONE问题，是否现在就保存上传!'))
      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
    Begin
      Result :='';
      Exit;
    End;
  end;

  FileName :=GetWinTempPath+'['+FormatDateTime('yyyymmdd',RequestDate)+']'+Get_GUID8+'.dat';
  if SaveSecThreeTrader(RecLst,PChar(FileName)) then
    Result :=FileName;
except

end;

end;

procedure TACBThreeTraderFrm.Btn_ApplyClick(Sender: TObject);
var
  FileName1,FileName2,FileName3 :String;
begin
  RequestDate:=DateSct.DateTime;
  Btn_Apply.Enabled:=false;
  DateSct.Enabled:=false;
  ListValue.ClearNodes;
  FileName1:=ReadNewDoc('threetrader@'+FormatDateTime('YYYYMMDD',DateSct.DateTime)+'.dat');
  if(Length(FileName1)=0)then
  begin
    ShowMessage(FAppParam.ConvertString('没有该天资料,也许还没到时间，或者该天是非交易日'+#13+'如果不是今天的你可以试着去补一下'));
    Btn_Apply.Enabled:=true;
    DateSct.Enabled:=true;
    exit;
  end;
  FileName2:=ReadNewDoc('threetraderlst.dat');
  FileName3:=ReadNewDoc('stkIndex.dat');
  //showMessage(FileName1 + #13#10 + FileName2 + #13#10 + FileName3);
  init(FileName1,FileName2,FileName3);
  Btn_Apply.Enabled:=true;
  DateSct.Enabled:=true;
end;


function TACBThreeTraderFrm.ReadNewDoc(const ReadTag: String): String;
var
  SResponse: string;
  AStream: TMemoryStream;
  decs: TDeCompressionStream;
  DstFile1 : String;
  Buffer: PChar;
  Count: integer;
begin
  IdTCPClient1.Port := 8090;
  IdTCPClient1.Host := FAppParam.DocServer;

  AStream := nil;
  Result := '';
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

        DstFile1 := GetWinTempPath+ReadTag;
        DeleteFile(DstFile1);
        if FileExists(DstFile1) Then
           Exit;
        AStream.SaveToFile(DstFile1);
        Result := DstFile1;
        Disconnect;
    end;
  end;
Except
  on e:Exception do
  begin
    //ShowMessage(e.Message);
    e := nil;
  end;
end;
finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;
end;



procedure TACBThreeTraderFrm.Btn_GetClick(Sender: TObject);
Var
  SResponse: string;
begin
   IdTCPClient1.Port := 8090;
   IdTCPClient1.Host := FAppParam.DocServer;
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
        WriteLn('SetThreeTrader');
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(FormatDateTime('yyyymmdd',DateGet.Date));
        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          ShowMessage( FAppParam.ConvertString('已加入回补队列'));
        Disconnect;
     end;
   end;
Except
  On E:Exception do
     //ShowMessage(E.Message);
End;
Finally
   IdTCPClient1.Disconnect;
end;
end;

procedure TACBThreeTraderFrm.DateGetClick(Sender: TObject);
begin
  Edt_Date.Text:=FormatDateTime('YYYY-MM-DD',DateGet.Date);
end;

procedure TACBThreeTraderFrm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin
  if  (ANode.Strings[ListValue.ColumnByName('Column_SecID').Index]='NONE') Then
  Begin
      AColor := clRed;
      AFont.Color := clBlack;
  end;

  if  ( AColumn.Index=0){or( AColumn.Index=1)} Then
  Begin
      AColor := $0080FFFF;
      AFont.Color := clBlack;
  end;
end;

procedure TACBThreeTraderFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
  Allow := false;
end;

end.
