unit CBDealerFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, dxTL, dxCntner,TDocMgr,TDocRW,TCommon,
  Buttons,ZLib, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,DateUtils,
  dxDBCtrl, dxDBGrid, dxTLClms;

type
  TACBDealerFrm = class(TFrame)
    Splitter1: TSplitter;
    Panel_Top: TPanel;
    Panel_Body: TPanel;
    Lbl_Caption: TLabel;
    PageCtl: TPageControl;
    TabSheet1: TTabSheet;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_SecDealer: TdxTreeListColumn;
    Column_SecDealerName: TdxTreeListColumn;
    Column_Sec: TdxTreeListColumn;
    Column_BuyCount: TdxTreeListColumn;
    Column_BuyPrice: TdxTreeListColumn;
    Column_SellCount: TdxTreeListColumn;
    Column_SellPrice: TdxTreeListColumn;
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
    Column_SecName: TdxTreeListPickColumn;
    Timer_CheckModify: TTimer;
    procedure Txt_MemoChange(Sender: TObject);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
    procedure ListValueEditChange(Sender: TObject);
    procedure ListValueEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure Btn_ApplyClick(Sender: TObject);
    procedure Btn_GetClick(Sender: TObject);
    procedure DateGetClick(Sender: TObject);
    procedure Column_SecNameChange(Sender: TObject);
    procedure Column_SecNameValidate(Sender: TObject;
      var ErrorText: String; var Accept: Boolean);
    procedure Timer_CheckModifyTimer(Sender: TObject);
  private
    { Private declarations }
    FNeedSaveUpload : Boolean;
    FHaveChangeData : Boolean;
    beChanged:Boolean;
    RequestDate:TDate;
    FNode : TdxTreeListNode;
    FSecIndexFileName:String;
    procedure init(AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName:String);
    Function GetSecName(aFileName,aSecID :String):String;
    Function GetSecID(aFileName,aSecName :String):String;
    Function AddSecName(aFileName:String):Boolean;
    function ReadNewDoc(const ReadTag: String): String;
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;Const AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName:String);
    Procedure Refresh(Const AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName:String);
    Function  GetFileName():String;
    procedure BeSave();
    function  NeedSave:Boolean;
  end;
implementation

{$R *.dfm}

{ TACBDealerFrm }

procedure TACBDealerFrm.BeSave;
begin
  FNeedSaveUpload := False;
end;

function TACBDealerFrm.NeedSave: Boolean;
begin
  Result := FNeedSaveUpload ;
end;

procedure TACBDealerFrm.Refresh(
  const AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName: String);
begin
    init(AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName);
end;

procedure TACBDealerFrm.SetInit(Parent: TWinControl;
  const AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName: String);
begin
  Self.Parent := Parent;
  Self.Align := alClient;

  Lbl_Caption.Caption :=FappParam.ConvertString('转换公司债自营商进出个股明细表数据            ');
  ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
  ListValue.Columns[1].Caption := FAppParam.ConvertString('证券交易商ID');
  ListValue.Columns[2].Caption := FAppParam.ConvertString('证券交易商名称');
  ListValue.Columns[3].Caption := FAppParam.ConvertString('证券ID');
  ListValue.Columns[4].Caption := FAppParam.ConvertString('证券名称');
  ListValue.Columns[5].Caption := FAppParam.ConvertString('买进数量');
  ListValue.Columns[6].Caption := FAppParam.ConvertString('买进金额');
  ListValue.Columns[7].Caption := FAppParam.ConvertString('卖出数量');
  ListValue.Columns[8].Caption := FAppParam.ConvertString('卖出金额');
  Btn_Apply.Caption := FAppParam.ConvertString('刷新');
  Tabsheet1.Caption := FAppParam.ConvertString('资料审核');
  TabSheet3.Caption := FAppParam.ConvertString('资料回补');
  Label1.Caption := FAppParam.ConvertString('当前选择的日期为            ');
  Label2.Caption := FAppParam.ConvertString('历史资料回补              ');

  Btn_Get.Caption := FAppParam.ConvertString('回补资料');
  Edt_Date.Text:=FormatDateTime('YYYY-MM-DD',DateGet.Date);
  DateSct.Date:=Date;
  DateGet.Date:=Date;

  //init(AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName);
end;

procedure TACBDealerFrm.Txt_MemoChange(Sender: TObject);
begin
  FNeedSaveUpload := True;
end;

procedure TACBDealerFrm.init(AcbDealerFilename,AcbDealerIndexFileName,ASecIndexFileName:String);
Var
  AItem : TdxTreeListNode;
  RecLst :Array of TDAILY_TRADE_RPT;
  i:integer;
begin
  beChanged:=false;
  FNeedSaveUpload := false;
  FSecIndexFileName:=ASecIndexFileName;
                                                  
  SetLength(RecLst,_GetSecDealerDataCount(PChar(AcbDealerFilename)));
  _GetSecDealerDataAll(RecLst);

  ListValue.ClearNodes;

  For i:=0 To High(RecLst) Do
  Begin
    AItem :=  ListValue.Add;
    AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
    AItem.Strings[ListValue.ColumnByName('Column_SecDealer').Index] :=RecLst[i].SEC_DEALER_ID;
    AItem.Strings[ListValue.ColumnByName('Column_SecDealerName').Index] :=StrPas(_GetSec_DealerName(PChar(String(RecLst[i].SEC_DEALER_ID)),PChar(AcbDealerIndexFileName)));
    AItem.Strings[ListValue.ColumnByName('Column_Sec').Index] :=RecLst[i].SEC_ID;
    AItem.Strings[ListValue.ColumnByName('Column_SecName').Index] :=GetSecName(ASecIndexFileName,Trim(RecLst[i].SEC_ID));
    AItem.Strings[ListValue.ColumnByName('Column_BuyCount').Index] :=IntToStr(RecLst[i].BUY_COUNT);
    AItem.Strings[ListValue.ColumnByName('Column_BuyPrice').Index] :=IntToStr(RecLst[i].BUY_PRICE);
    AItem.Strings[ListValue.ColumnByName('Column_SellCount').Index] :=IntToStr(RecLst[i].SELL_COUNT);
    AItem.Strings[ListValue.ColumnByName('Column_SellPrice').Index] :=IntToStr(RecLst[i].SELL_PRICE);
  End;

  //init the combBox
  AddSecName(ASecIndexFileName);
end;

Function TACBDealerFrm.GetSecName(aFileName,aSecID :String):String;
Var
  StrLst :TStringList;
  i:Integer;
Begin
  Result :='NONE';
  StrLst :=TStringList.Create;
try
  StrLst.LoadFromFile(aFileName);
  For i:=0 To StrLst.Count-1 Do
  Begin

    if(Pos(aSecID,StrLst.Strings[i])>0)then
    begin
      Result := Copy(StrLst.Strings[i],Pos(',',Strlst.Strings[i])+1,Length(StrLst.Strings[i])-Pos(',',Strlst.Strings[i]));
      Break;
    end;

  End;
except

end;
  try
    {if Assigned(StrLst)then
      Strlst.Free;}
  except
  end;
End;

Function TACBDealerFrm.GetSecID(aFileName,aSecName :String):String;
Var
  StrLst :TStringList;
  i:Integer;
Begin
  Result :='NONE';
  StrLst :=TStringList.Create;
try
  StrLst.LoadFromFile(aFileName);
  For i:=0 To StrLst.Count-1 Do
  Begin

    //if(Pos(aSecName,StrLst.Strings[i])>0)then
    if(Copy(StrLst.Strings[i],Pos(',',Strlst.Strings[i])+1,Length(StrLst.Strings[i])-Pos(',',Strlst.Strings[i]))=aSecName)then
    begin
      Result := Copy(StrLst.Strings[i],1,Pos(',',Strlst.Strings[i])-1);
      Break;
    end;

  End;
except

end;
  try
    {if Assigned(StrLst)then
      Strlst.Free;}
  except
  end;
End;

Function TACBDealerFrm.AddSecName(aFileName:String):Boolean;
Var
  StrLst :TStringList;
  i:Integer;
Begin
  Result :=false;
  StrLst :=TStringList.Create;
try
  StrLst.LoadFromFile(aFileName);
  TdxTreeListPickColumn(ListValue.ColumnByName('Column_SecName')).Items.Clear;
  For i:=0 To StrLst.Count-1 Do
  Begin
    TdxTreeListPickColumn(ListValue.ColumnByName('Column_SecName')).Items.Add(Copy(StrLst.Strings[i],Pos(',',Strlst.Strings[i])+1,Length(Strlst.Strings[i])-Pos(',',Strlst.Strings[i])));
    Result :=true;
  End;
except

end;
  try
    {if Assigned(StrLst)then
      Strlst.Free;}
  except
  end;
End;

function TACBDealerFrm.GetFileName: String;
var
  AItem : TdxTreeListNode;
  RecLst :Array of TDAILY_TRADE_RPT;
  i:integer;
  FileName :String;
  haveNone:Boolean;
begin
  Result :='';
  havenone :=false;
try

  if(ListValue.Count=0)then exit;
  For i:=0 to ListValue.Count-1 do
  Begin
    AItem :=  ListValue.Items[i];
    SetLength(RecLst,High(RecLst)+2);

    if(Trim(AItem.Strings[ListValue.ColumnByName('Column_Sec').Index])='NONE')then
      HaveNone:=true;

    RecLst[High(RecLst)].SEC_ID        :=Trim(AItem.Strings[ListValue.ColumnByName('Column_Sec').Index]);
    RecLst[High(RecLst)].SEC_DEALER_ID :=Trim(AItem.Strings[ListValue.ColumnByName('Column_SecDealer').Index]);
    RecLst[High(RecLst)].BUY_COUNT     :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_BuyCount').Index]));
    RecLst[High(RecLst)].BUY_PRICE     :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_BuyPrice').Index]));
    RecLst[High(RecLst)].SELL_COUNT    :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_SellCount').Index]));
    RecLst[High(RecLst)].SELL_PRICE    :=StrToInt(Trim(AItem.Strings[ListValue.ColumnByName('Column_SellPrice').Index]));

  End;
  if(HaveNone)then
  begin
    if (IDOK<>MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('该天的自营商资料中包含NONE问题，是否现在就保存上传!'))
      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
    Begin
      Result :='';
      Exit;
    End;
  end;

  FileName :=GetWinTempPath+'['+FormatDateTime('yyyymmdd',RequestDate)+']'+Get_GUID8+'.dat';
  if(_SaveSecDealerData(RecLst,PChar(FileName)))then
    Result :=FileName;

except

end;

end;

procedure TACBDealerFrm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin

  if  (ANode.Strings[ListValue.ColumnByName('Column_Sec').Index]='NONE') Then
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

procedure TACBDealerFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
  if(Node.Strings[ListValue.ColumnByName('Column_Sec').Index]='NONE')then
   Allow :=(ListValue.FocusedColumn<>0)and
           (ListValue.FocusedColumn<>1)and
           (ListValue.FocusedColumn<>2)and
           (ListValue.FocusedColumn<>3)
  else
   Allow :=(ListValue.FocusedColumn<>0)and
           (ListValue.FocusedColumn<>1)and
           (ListValue.FocusedColumn<>2)and
           (ListValue.FocusedColumn<>3)and
           (ListValue.FocusedColumn<>4) ;
end;

procedure TACBDealerFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData :=  True;
end;

procedure TACBDealerFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
var
  AItem : TdxTreeListNode;
  Str :String;
  i:Integer;
begin
try
  if FHaveChangeData then
  For i:=0 to ListValue.Count-1 do
  Begin
  
    AItem :=  ListValue.Items[i];   

    Str := AItem.Strings[ListValue.ColumnByName('Column_BuyCount').Index]; 
    if Not isInteger(PChar(Str)) Then 
       Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.')); 

    Str := AItem.Strings[ListValue.ColumnByName('Column_BuyPrice').Index]; 
    if Not isInteger(PChar(Str)) Then 
       Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.')); 

    Str := AItem.Strings[ListValue.ColumnByName('Column_SellCount').Index]; 
    if Not isInteger(PChar(Str)) Then 
       Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.')); 

    Str := AItem.Strings[ListValue.ColumnByName('Column_SellPrice').Index];
    if Not isInteger(PChar(Str)) Then
       Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));

  End;
finally

end;
  FHaveChangeData := false;
  FNeedSaveUpload := True;

end;

procedure TACBDealerFrm.Btn_ApplyClick(Sender: TObject);
var
  FileName1,FileName2,FileName3 :String;
begin
  RequestDate:=DateSct.DateTime;
  {if(DayOfTheWeek(RequestDate)=6)or(DayOfTheWeek(RequestDate)=7)then
  begin
    ShowMessage(FAppParam.ConvertString('放假时哪有资料???'));
    exit;
  end;}
  Btn_Apply.Enabled:=false;
  DateSct.Enabled:=false;
  ListValue.ClearNodes;
  FileName1:=ReadNewDoc('cbdealer@'+FormatDateTime('YYYYMMDD',DateSct.DateTime)+'.dat');
  if(Length(FileName1)=0)then
  begin
    ShowMessage(FAppParam.ConvertString('没有该天资料,也许还没到时间，或者该天是非交易日'+#13+'如果不是今天的你可以试着去补一下'));
    Btn_Apply.Enabled:=true;
    DateSct.Enabled:=true;
    exit;
  end;
  FileName2:=ReadNewDoc('cbdealerindex.dat');
  FileName3:=ReadNewDoc('SecIndex.dat');
  init(FileName1,FileName2,FileName3);
  Btn_Apply.Enabled:=true;
  DateSct.Enabled:=true;
end;

function TACBDealerFrm.ReadNewDoc(const ReadTag: String): String;
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
end;

finally
   IdTCPClient1.Disconnect;
   if AStream<>nil Then
      AStream.Free;
end;

end;

procedure TACBDealerFrm.Btn_GetClick(Sender: TObject);
Var
  SResponse: string;
begin

  {if(DayOfTheWeek(DateGet.Date)=6)or(DayOfTheWeek(DateGet.Date)=7)then
  begin
    ShowMessage(FAppParam.ConvertString('放假时哪有资料???'));
    exit;
  end; }

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

        WriteLn('SetDealer');

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
          WriteLn(FormatDateTime('yyyymmdd',DateGet.Date));

        SResponse := UpperCase(ReadLn);
        if Pos('HELLO', SResponse) > 0 then
        Begin
          ShowMessage( FAppParam.ConvertString('已加入回补队列'));
        End;
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

procedure TACBDealerFrm.DateGetClick(Sender: TObject);
begin
  Edt_Date.Text:=FormatDateTime('YYYY-MM-DD',DateGet.Date);
end;

procedure TACBDealerFrm.Column_SecNameChange(Sender: TObject);
begin
  //
end;

procedure TACBDealerFrm.Column_SecNameValidate(Sender: TObject;
  var ErrorText: String; var Accept: Boolean);
var
  ANode : TdxTreeListNode;
begin
  ANode:=ListValue.FocusedNode;
  //showmessage(ANode.Strings[ListValue.ColumnByName('Column_SecName').Index]);
  beChanged:=true;
  FNode:=ANode;
end;

procedure TACBDealerFrm.Timer_CheckModifyTimer(Sender: TObject);
begin
  Timer_CheckModify.Enabled:=false;
try
  sleep(1);
  Application.ProcessMessages;
  if(beChanged)then
  begin
    FNode.Strings[ListValue.ColumnByName('Column_Sec').Index]:=GetSecID(FSecIndexFileName,FNode.Strings[ListValue.ColumnByName('Column_SecName').Index]);{FNode.Strings[ListValue.ColumnByName('Column_SecName').Index]; }
    ListValue.Repaint;
    beChanged:=false;
  end;
except

end;

  Timer_CheckModify.Enabled:=true;
end;

end.
