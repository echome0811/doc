{*****************************************************************************
 创建标示：CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
 功能标示：公告加载速度过慢，调整为直接读取个股公告列表，默认加载一周内公告，
           可选择加载全部公告，公告按日期降序显示在界面。
           2、完善公告可勾选功能20080328
////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求1-leon-08/8/13;(修改TW-CBDatEdit中的"停止转换期间"在新增转债代码节点时，新增的节点信息会将鼠标上一个焦点下的转债代码的信息内容覆盖）
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18;(修改CBDatEdit的“停止转换期间”的代码在查找公告时的对应代码查找逻辑，将原本的直接删减，变成查询tr1db中的txt文件)
////////////////////////////////////////////////////////////////////////////
//--Doc3.2.0需求2 huangcq080926 修改bug:停止转换期间没有任何更改却仍然提示是否保存
*****************************************************************************}
unit CBStopConvFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr,TDocRW, dxTLClms;

type

  TAStopConvInfo=Record
     Days : String;
     Per  : Double;
  End;

  TCodeList=Record     //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    TradeCode:string[8];
    StkCode:string[8];
  end;
  PCodeList=^TCodeList;

  TDocTitle = Record
    ID:String;
    Index :Integer;
    Date :String;
    Title :String;
    RtfPath :String;
    DocType:byte;
    StrikeType:byte;
  End;
  PDocTitle=^TDocTitle;
  PAllDocTitle=^TDocTitle;//完善公告可勾选功能20080328 add
  TStopConvInfoMgr=Class
  private
    FFileName : String;
    FRecLst : array of TSTOPCONV_PERIOD_RPT;
    FDateLst: array of TSTOPCONV_PERIOD_DETAIL;
    FNowID : String;
    FFileMemo:TStringList;
    FAStopConvInfo: TAStopConvInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    procedure Sort(Var aRecLst:Array of TSTOPCONV_PERIOD_DETAIL);
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetAStopConvInfo(const Value: TAStopConvInfo);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure ReadStopConvDate(Const ID:String);
    procedure GetStopConvDate(Const ID:String;var DateLst:Array of TSTOPCONV_PERIOD_DETAIL);
    procedure SaveStopConvDate(Const ID:String;Const DateLst:Array of TSTOPCONV_PERIOD_DETAIL);
    procedure SaveDocDat();
    procedure Setbesave();
    Function UpdateAID(Var ID:String;nowID:String):Boolean;
    procedure DelDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID(ID :String):Boolean;
    Function GetMemoText():String;
    Function GetStopConvFileName:String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property AStopConvInfo : TAStopConvInfo read FAStopConvInfo write SetAStopConvInfo;
  End;

  TACBStopConvFrm = class(TFrame)
    Panel_Left: TPanel;
    Panel_Right: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel4: TPanel;
    Panel2: TPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Panel_NowID: TPanel;
    Bevel5: TBevel;
    Btn_Refresh: TSpeedButton;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A2: TdxTreeListColumn;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    Splitter2: TSplitter;
    ListValue_doc: TdxTreeList;
    Column_Num_doc: TdxTreeListColumn;
    Column_Chk: TdxTreeListCheckColumn;
    Column_A1_doc: TdxTreeListColumn;
    Column_A3_doc: TdxTreeListColumn;
    Column_A4_doc: TdxTreeListColumn;
    Column_A3: TdxTreeListColumn;
    btnAddAlldoc: TSpeedButton;
    Column_A5_doc: TdxTreeListColumn;
    Column_A6_doc: TdxTreeListColumn;
    procedure Cbo_SectionChange(Sender: TObject);
    procedure Txt_MemoChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
    procedure Txt_InfoChange(Sender: TObject);
    procedure ListValueEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure Btn_RefreshClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure ListValueEditChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListValue_docDblClick(Sender: TObject);
    procedure ListValueClick(Sender: TObject);
    procedure btnAddAlldocClick(Sender: TObject);
  private
    { Private declarations }
    AStopConvInfoMgr : TStopConvInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    nowindex:integer;
    FDocLst :TList;
    FDocLstFile :String;
    k:integer;
    DateLst:Array of TSTOPCONV_PERIOD_DETAIL;
    Procedure CreateDefauleItem();
    procedure Init(Const FileName:String);

  public
    { Public declarations }
    FCodeLst : TList;
    FFileLst : _CstrLst; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    FDocTypeList,FStrikeTypeList:TStringList;
    
    function SaveDocData():boolean;
    Procedure LoadDocData();
    Procedure ShowLoadDocData();
    Procedure ShowDocData();
    Procedure SaveStopConvData(aindex:integer);
    procedure Sort(Var aRecLst:Array of TSTOPCONV_PERIOD_DETAIL);
    Procedure SetInit(Parent:TWinControl;Const FileName,adoclstfile:String);
    Function GetMemoText():String;
    Procedure Refresh(Const FileName:String);
    Function NeedSave():Boolean;
    Procedure BeSave();
    Function GetFileName:String;
    function LoadDocTitle(aindex:integer):Boolean;
    function ReadDoclst(aID:String;var aDocLst:TList):Boolean;
    Function GetTitle(aindex:integer;aID,aStr:String;var aDocTitle:PDocTitle):Boolean;
    Function GetTitle2(aindex:integer;aID,aStr:String;var aDocTitle:PAllDocTitle):Boolean; //完善公告可勾选功能20080328 add
    Function GetTitle3(aindex:integer;aID,aStr,aStr2:String;var aDocTitle:PDocTitle):Boolean;
    Function GetTitle33(aindex:integer;aID,aStr,aStr2:String;var aDocTitle:PAllDocTitle):Boolean;
    procedure RefID();
    function CheckStkCode(var AID:String):boolean;   //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  DownDBdata():_CstrLst;            //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadTreadCode(FileName:string;index:string):string; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadStockCode(FileName:string;index:string):string; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadCodetoList:boolean; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;

    function I2SDocType(i:integer):string;
    function I2SStrikeType(i:integer):string;
  end;


implementation
uses
  MainFrm;
var
  AMainFrm: TAMainFrm;

{$R *.dfm}

{ TACBDocFrm }

procedure TACBStopConvFrm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;
   CreateDefauleItem;

   if Not Assigned(AStopConvInfoMgr) Then
      AStopConvInfoMgr := TStopConvInfoMgr.Create(FileName);

   BeSave;

   List_ID.Clear;
   For i:=0 to AStopConvInfoMgr.IDCount-1 do
       List_ID.Items.Add(AStopConvInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      ShowDocData;
   End;
   List_IDClick(nil);

end;

procedure TACBStopConvFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  //AStopConvInfoMgr.ReadDocDat(ID);
end;

procedure TACBStopConvFrm.SetInit(Parent: TWinControl;Const FileName,adoclstfile:String);
var sFile,sLine:string;
    fini:TiniFile;
    i,iCount:integer;
begin
    Column_A5_doc.Visible:=FAppParam.IsTwSys;
    Column_A6_doc.Visible:=FAppParam.IsTwSys;
    
    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('开始日期');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('停止日期');

    ListValue_doc.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue_doc.Columns[1].Caption := FAppParam.ConvertString('勾选');
    Column_A5_doc.Caption := FAppParam.ConvertString('公告类型');
    Column_A6_doc.Caption := FAppParam.ConvertString('种类');
    Column_A1_doc.Caption := FAppParam.ConvertString('日期');
    Column_A3_doc.Caption := FAppParam.ConvertString('公告');

    Self.Parent := Parent;
    Self.Align := alClient;
    FDocLst :=TList.Create;
    FCodeLst:=TList.Create;
    //FDocLstFile:= adoclstfile;
    FDocTypeList:=TStringList.Create;
    FStrikeTypeList:=TStringList.Create;
    sFile:=ExtractFilePath(ParamStr(0))+'ShenBao.ini';
    if FileExists(sFile) then
    try
      fini:=TIniFile.create(sFile);
      iCount:=fini.ReadInteger('ShenBaoDocTypeList','count',0);
      for i:=1 to iCount do
      begin
        sLine:=fini.ReadString('ShenBaoDocTypeList',IntToStr(i),'');
        FDocTypeList.Add(sLine);
      end;
      iCount:=fini.ReadInteger('StrikeChangeList','count',0);
      for i:=1 to iCount do
      begin
        sLine:=fini.ReadString('StrikeChangeList',IntToStr(i),'');
        FStrikeTypeList.Add(sLine);
      end;
    finally
      try FreeAndNil(fini); except end;
    end;

  if not ReadCodetoList then  //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
     showmessage(FAppParam.ConvertString('转换股票代码没有加载成功，请重新启动'));//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;

    Init(FileName);


end;

procedure TACBStopConvFrm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  Str : String;
begin

    FLockMemoChange := True;
Try

   ListValue.ClearNodes;

   CreateDefauleItem;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  AStopConvInfoMgr.AStopConvInfo Do
     Begin
       Str := '';
       Case i of
            0: Str := Days;
            1: Str := FloatToStr(Per);
       End;
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] :=Str;
     End;
   End;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBStopConvFrm.ShowDocData;
Var
  ID : String;
  AItem : TdxTreeListNode;
  i:integer;
  //DateLst:Array of TSTOPCONV_PERIOD_DETAIL;
begin
try
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);

  ListValue.ClearNodes;

  SetLength(DateLst,0);
  SetLength(DateLst,16);
  AStopConvInfoMgr.GetStopConvDate(ID,DateLst);

  For i:=0 to High(DateLst)do
  begin
    AItem :=  ListValue.Add;
    AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
    if(DateLst[i].START_DATE=66842)then
    begin
      AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := 'NONE';
    end
    else
    begin
      AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FormatDateTime('YYYY-MM-DD',DateLst[i].START_DATE);
      AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := FormatDateTime('YYYY-MM-DD',DateLst[i].END_DATE);
      AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := DateLst[i].DOC_FILENAME;
    end;
  end;

except

end;

End;

procedure TACBStopConvFrm.SaveStopConvData(aindex:integer);
Var
  ID : String;
  AItem : TdxTreeListNode;
  i:integer;
  DateLst:Array of TSTOPCONV_PERIOD_DETAIL;
  FDateSeparator:char;
begin
try
  if aindex<0 Then Exit;
  ID :=  List_ID.Items[aindex];

  SetLength(DateLst,0);
  SetLength(DateLst,16);

  FDateSeparator:=DateSeparator;
  DateSeparator:='-';
  For i:=0 to ListValue.Count-1 do
  begin
    AItem :=  ListValue.Items[i];
    if(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]='NONE')then
    begin
      DateLst[i].START_DATE := 0;
      DateLst[i].END_DATE := 0;
      DateLst[i].DOC_FILENAME :='NONE';
    end
    else
    begin
      DateLst[i].START_DATE := strToDate(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
      DateLst[i].END_DATE := strToDate(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
      DateLst[i].DOC_FILENAME :=AItem.Strings[ListValue.ColumnByName('Column_A3').Index];
    end;
  end;
  DateSeparator:=FDateSeparator;

  Sort(DateLst);
  AStopConvInfoMgr.SaveStopConvDate(ID,DateLst);

except

end;

End;

procedure TACBStopConvFrm.Sort(Var aRecLst:Array of TSTOPCONV_PERIOD_DETAIL);
var
  i,j:integer;
  Rec_tmp :TSTOPCONV_PERIOD_DETAIL;
begin
try
  if(High(aRecLst)=-1)then exit;
  For i:=0 To High(aRecLst)-1 Do
  Begin
    For j:=i+1 To High(aRecLst) Do
    begin
      if((aRecLst[i].START_DATE)>(aRecLst[j].START_DATE))then
      begin
        Rec_tmp:=aRecLst[i];
        aRecLst[i]:=aRecLst[j];
        aRecLst[j]:=Rec_tmp;
      end
    end;
  End;
except
end;
end;

function TACBStopConvFrm.SaveDocData :boolean;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TAStopConvInfo;
  Str : String;
begin

Try

   ADateInfo  := AStopConvInfoMgr.AStopConvInfo;
   Result:=false; 

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];

     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
     if Length(Str)>0 Then
     Begin
        if (str<>'NONE')then
        if Not IsDate(Str) Then
          Raise Exception.Create(FAppParam.ConvertString('第'+IntTostr(i+1)+'行日期输入错误'));
     End;

     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
     if Length(Str)>0 Then
     Begin
        if (str<>'NONE')then
        if Not IsDate(Str) Then
          Raise Exception.Create(FAppParam.ConvertString('第'+IntTostr(i+1)+'行日期输入错误'));
     End;
   End;

    if FHaveChangeData=true then //--Doc3.2.0需求2 huangcq080926 add
    begin
      AStopConvInfoMgr.Setbesave;//FHaveChangeData<>true则没调用本句，也不会出现FNeedSaveUpload:=True
      SaveStopConvData(nowindex); //--Doc3.2.0需求2 huangcq080926 add
    end;

    FHaveChangeData := False;
    Result:=true;
    //AStopConvInfoMgr.Setbesave; //--Doc3.2.0需求2 huangcq080926 del  被前移

except
  On E:Exception do
    ShowMessage(E.Message);
End;

end;

function TACBStopConvFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
  SaveDocData;

  Result := '';
  if Assigned(AStopConvInfoMgr) Then
     Result := AStopConvInfoMgr.GetMemoText;  

end;

{ TStopConvInfoMgr }

constructor TStopConvInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TStopConvInfoMgr.CreateAID(var ID: String): Boolean;
Var
  i ,j: Integer;
begin

   Result := False;
   if Not NewAID(ID) Then
      Exit;

   For i:=0 to High(FRecLst) do
   Begin
      if FRecLst[i].ID=ID Then
      Begin
         ShowMessage(FAppParam.ConvertString('代码已存在.'));
         Exit;
      End;
   End;

   i := High(FRecLst)+1;
   SetLength(FRecLst,i+1);
   FRecLst[i].ID := ID;
   For j:=0 to 14 do
   begin
     FRecLst[i].ASTOPCONV_DETAILS[j].DOC_FILENAME :='NONE';
     FRecLst[i].ASTOPCONV_DETAILS[j].START_DATE:=0;
     FRecLst[i].ASTOPCONV_DETAILS[j].END_DATE:=0;
   end;

   //ReadDocDat(ID);
    FNeedSaveUpload := True;
   Result := True;

end;


function TStopConvInfoMgr.DelAID(ID :String): Boolean;
Var
  i,j : Integer;
begin

   Result := False;

Try
Try

   For i:=0 to High(FRecLst) do
   Begin
      if FRecLst[i].ID=ID Then
      Begin
         for j:=i to High(FRecLst)-1 do
           FRecLst[j] := FRecLst[j+1];
        SetLength(FRecLst,High(FRecLst));
        //DelDocDat;
        FNowID := '';
        FNeedSave := False;
        FNeedSaveUpload := True;
        Result := True;
      End;
   End;

Except
End;
Finally
End;



end;

procedure TStopConvInfoMgr.DelDocDat;
Var
  Str : String;
  i : Integer;
Begin

  if Length(FNowID)=0 Then
    Exit;

  Try
  Try

   For i:=0 to FFileMemo.Count-1 do
   Begin
      Str := Trim(FFileMemo.Strings[i]);
      if Pos('ID='+FNowID,Str)>0 Then
      Begin
        FFileMemo.Delete(i); 
        Break;
      End;
   End;

  Except
  End;
  Finally
  End;

end;

destructor TStopConvInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TStopConvInfoMgr.GetID(Index: Integer): String;
begin
   Result := FRecLst[Index].ID;
end;

function TStopConvInfoMgr.GetIDCount: Integer;
begin
   Result := High(FRecLst)+1;
end;

function TStopConvInfoMgr.GetMemoText: String;
Var
  f : TStringList;
  i : Integer;
  Str : String;
begin
   SaveDocDat;
   f := nil;
Try
try
   f := TStringList.Create;
   f.Add('[STRIKE]');
   for i:=0 to  FFileMemo.Count-1 do
   Begin
       Str := FFileMemo.Strings[i];
       ReplaceSubString('ID=',IntToStr(i+1)+'=',Str);
       f.Add(Str);
   End;
   Result := f.Text;

Except
End;
Finally
  if Assigned(f) Then
     f.Free;
End;

end;

procedure TStopConvInfoMgr.Init;
Var
  //i,j,p1,p2 : Integer;  //20070920删除
  f : TStringList;
  //Str : String;//20070920删除
begin

   f := nil;
try
try

   FNeedSave := False;
   SetLength(FRecLst,0);
   SetLength(FRecLst,_GetSecStopConvDataCount(PChar(FFileName)));
   _GetStopConvDataAll(FRecLst);

   SortIDLst2(FRecLst);
except
  On E:Exception Do
     ShowMessage(E.Message);
End;
Finally
  if Assigned(f) Then
     f.Free;
End;
end;

procedure TStopConvInfoMgr.Sort(Var aRecLst:Array of TSTOPCONV_PERIOD_DETAIL);
var
  i,j:integer;
  Rec_tmp :TSTOPCONV_PERIOD_DETAIL;
begin
try
  if(High(aRecLst)=-1)then exit;
  For i:=0 To High(aRecLst)-1 Do
  Begin
    For j:=i+1 To High(aRecLst) Do
    begin
      if((aRecLst[i].START_DATE)>(aRecLst[j].START_DATE))then
      begin
        Rec_tmp:=aRecLst[i];
        aRecLst[i]:=aRecLst[j];
        aRecLst[j]:=Rec_tmp;
      end
    end;
  End;
except
end;
end;

procedure TStopConvInfoMgr.ReadDocDat(const ID: String);
Var
  Str : String;
  StrLst:_CStrLst2;
  i : integer;
Begin

  SaveDocDat;

  FNowID := ID;
  With FAStopConvInfo Do
  Begin
      Days := '';
      Per  := 0;
  End;

  Try
  Try
   For i:=0 to FFileMemo.Count-1 do
   Begin
      Str := Trim(FFileMemo.Strings[i]);
      if Pos('ID='+FNowID,Str)>0 Then
      Begin
        SetLength(StrLst,0);
        StrLst := DoStrArray2(Str,',');
        With FAStopConvInfo Do
        Begin
          Days := StrLst[1];
          Per := StrToFloat(StrLst[2]);
        End;
        Break;
      End;
   End;
  Except
  End;
  Finally
  End;





end;

procedure TStopConvInfoMgr.ReadStopConvDate(const ID: String);
var
  i,j:integer;
begin
  SetLength(FDateLst,0);
  For i:=0 to High(FRecLst) do
  Begin
    if(FRecLst[i].ID=ID)then
    Begin
      For j:=0 To high(FRecLst[i].ASTOPCONV_DETAILS) do
      begin
        SetLength(FDateLst,High(FDateLst)+2);
        FDateLst[high(FDateLst)].DOC_FILENAME:=FRecLst[i].ASTOPCONV_DETAILS[j].DOC_FILENAME;
        FDateLst[high(FDateLst)].START_DATE:=FRecLst[i].ASTOPCONV_DETAILS[j].START_DATE;
        FDateLst[high(FDateLst)].END_DATE:=FRecLst[i].ASTOPCONV_DETAILS[j].END_DATE;
      end;
      break;
    End;
  End;

  For i:=0 to High(FDateLst) do
  begin
    if(FDateLst[i].START_DATE=0)then
      FDateLst[i].START_DATE := 66842;
  end;

  Sort(FDateLst);
end;

procedure TStopConvInfoMgr.GetStopConvDate(Const ID:String;var DateLst:Array of TSTOPCONV_PERIOD_DETAIL);
var
  i:integer;
begin
  ReadStopConvDate(ID);

  For i:=0 To high(FDateLst) do
  begin
    DateLst[i]:=FDateLst[i];
  end;
end;

procedure TStopConvInfoMgr.SaveStopConvDate(Const ID:String;Const DateLst:Array of TSTOPCONV_PERIOD_DETAIL);
var
  i,j:integer;
begin
try
  For i:=0 to High(FRecLst) do
  Begin
    if(FRecLst[i].ID=ID)then
    Begin
      For j:=0 To high(FRecLst[i].ASTOPCONV_DETAILS) do
      begin
        FRecLst[i].ASTOPCONV_DETAILS[j].DOC_FILENAME:=DateLst[j].DOC_FILENAME;
        FRecLst[i].ASTOPCONV_DETAILS[j].START_DATE:=DateLst[j].START_DATE;
        FRecLst[i].ASTOPCONV_DETAILS[j].END_DATE:=DateLst[j].END_DATE;
      end;
      break;
    End;
  End;
   FNeedSaveUpload := True;
except

end;

end;

procedure TStopConvInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TStopConvInfoMgr.SaveDocDat;
Var
  Str : String;
  i : Integer;
Begin

  if Length(FNowID)=0 Then
    Exit;

  if Not FNeedSave Then
     Exit;
  Try
  Try

   For i:=0 to FFileMemo.Count-1 do
   Begin
      Str := Trim(FFileMemo.Strings[i]);
      if Pos('ID='+FNowID,Str)>0 Then
      Begin
        With  FAStopConvInfo do
        Begin
          Str := Days;
          ReplaceSubString(',','',Str);
          Days := Str;
          FFileMemo.Strings[i] := Format('ID=%s,%s,%s',
                                         [FNowID,Days,FloatToStr(Per)]);
        End;
        Break;
      End;
   End;

  Except
  End;
  Finally
     FNeedSave := False;
  End;
end;


procedure TACBStopConvFrm.Cbo_SectionChange(Sender: TObject);
begin
  //ShowLoadDocData;
end;

procedure TACBStopConvFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBStopConvFrm.List_IDClick(Sender: TObject);
begin
   //LoadDocData;
   //ShowLoadDocData;
   if SaveDocData then
   begin
     //SaveStopConvData(nowindex); //--Doc3.2.0需求2 huangcq080926 del
     ShowDocData;
     nowindex:=List_ID.ItemIndex;
     LoadDocTitle(nowindex);
   end
   else
     List_ID.ItemIndex:=nowindex;

end;


procedure TStopConvInfoMgr.SetAStopConvInfo(
  const Value: TAStopConvInfo);
begin
  FAStopConvInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBStopConvFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0);
end;

procedure TACBStopConvFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBStopConvFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBStopConvFrm.CreateDefauleItem;
Var
  AItem : TdxTreeListNode;
begin
{   ListValue.ClearNodes;

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(1);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('交易日数');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(2);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('上浮幅度');
 }

end;

procedure TACBStopConvFrm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin

  if  ( AColumn.Index=0)Then
  Begin
      AColor := $0080FFFF;
      AFont.Color := clBlack;
  end;

end;

procedure TACBStopConvFrm.Btn_RefreshClick(Sender: TObject);
begin
   ShowDocData;
end;

procedure TACBStopConvFrm.Refresh(const FileName: String);
begin
   AStopConvInfoMgr.Reback(FileName);
   Init(FileName);
   ShowDocData;
end;

////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求1-leon-08/8/13;
//在每次新增完ID后，将当前焦点的index传给代表当前焦点index的nowindex参数，达到准确定位的目的；不会在新增后还是将值传给上次定位的ID中；
////////////////////////////////////////////////////////////////////////////
procedure TACBStopConvFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if AStopConvInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      nowindex:=List_ID.ItemIndex;//add by leon 080813
      ShowDocData;
   End;
end;
//////////////////////////////////////////////////////////////////////////

procedure TACBStopConvFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if AStopConvInfoMgr.DelAID(List_ID.Items[List_ID.ItemIndex]) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Del',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      CreateDefauleItem;

      Index := List_ID.ItemIndex;
      List_ID.Items.Delete(List_ID.ItemIndex);

      if Index>List_ID.Count-1 Then
         Index := List_ID.Count-1;
      if Index>=0 Then
      Begin
        List_ID.ItemIndex := Index;
        ShowDocData;
      End;
   End;
Finally
End;



end;

procedure TACBStopConvFrm.Txt_IDChange(Sender: TObject);
Var
  i,j        : Integer;
  TempStr,ID : ShortString;
begin
  ID :=  Trim(Txt_ID.Text);
  if Length(ID)>0 Then
  begin
    i:=0;
    while i<List_ID.Count do
    Begin
      if Length(List_ID.Items.Strings[i])<Length(ID) then
         exit
      else
      begin
        TempStr:='';
        for j:=1 to length(ID) do
        begin
          TempStr:=TempStr+List_ID.Items.Strings[i][j];
        end;
        if ID=TempStr Then
        Begin
          List_ID.ItemIndex := i;
          if(List_ID.ItemIndex<>k)then
          begin
            //LoadDocData;
            //ShowLoadDocData;
            List_IDClick(sender);
            k:=List_ID.ItemIndex;
          end;
          Break;
        End;
      end;
      i:=i+1;
    End;
  end;
end;

function TACBStopConvFrm.NeedSave: Boolean;
begin
   Result := AStopConvInfoMgr.FNeedSaveUpload
end;

procedure TACBStopConvFrm.BeSave;
begin

  AStopConvInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBStopConvFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData :=  True;
end;

function TStopConvInfoMgr.UpdateAID(var ID: String; nowID:String): Boolean;
Var
 i,j : Integer;
 Str : String;
begin

   Result := False;
   ID:=nowID;
   if Not ModifyAID(ID) Then
      Exit;

   For i:=0 to High(FRecLst) do
   Begin
      if FRecLst[i].ID=ID Then
      Begin
         ShowMessage(FAppParam.ConvertString('代码已存在.'));
         Exit;
      End;
   End;

   for i:=0 to High(FRecLst) do
     if FRecLst[i].ID=NowID Then
     Begin
        FRecLst[i].ID:=ID;
        Break;
     End;

      FNeedSaveUpload := True;
   Result := True;
end;

procedure TACBStopConvFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin
   if List_ID.ItemIndex<0 Then
      exit;
   if AStopConvInfoMgr.UpdateAID(ID,List_ID.Items[List_ID.ItemIndex]) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;
end;

function TACBStopConvFrm.GetFileName: String;
begin
try
  //SaveStopConvData(List_ID.ItemIndex);
  SaveStopConvData(nowindex);  
  Result:=AStopConvInfoMgr.GetStopConvFileName;
except

end;

end;

function TACBStopConvFrm.LoadDocTitle(aindex:integer): Boolean;
var
  ID : String;
  i,j: integer; //添加变量j
  AItem : TdxTreeListNode;
  DocTitle,DocTitle2 :PDocTitle;  //添加变量DocTitle2
  DocTemp:TList; //添加变量
begin
  result := false;
  try
    if List_ID.ItemIndex<0 Then Exit;
    ID :=  List_ID.Items[aindex];
    FDocLst.Clear;

    if FAppParam.IsTwSys then
    begin

    end
    else begin
      if not CheckStkCode(ID) then
      begin
        showmessage(FAppParam.ConvertString('系统中未查到与该代码对应的股票代码。'));
        exit;      //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
      end;
      if ID='' then
      begin
          showmessage(FAppParam.ConvertString('系统中查询该代码对应的股票代码为空，请联系系统管理人员。'));
          exit;
      end;
    end;

    ReadDoclst(ID,FDocLst);     //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;

    new(DocTitle);
    ListValue_doc.ClearNodes;
    ListValue_doc.Refresh;
    For i:=0 To FDocLst.Count-1 Do
    Begin
      //CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
     //---------------------------公告按时间降序排序
    for j:=i+1 to FDocLst.Count-1 do
      begin
        DocTitle := FDocLst[i];
        DocTitle2:=FDocLst[j];
        if DocTitle.Date<DocTitle2.date then
        begin
         DocTemp:=FDocLst[i];
         FDocLst[i]:=FDocLst[j];
         FDocLst[j]:=DocTemp;
        end;
      end;
    //---------------------------公告按时间降序排序
      DocTitle := FDocLst[i];
      AItem := ListValue_doc.Add;
      AItem.Strings[ListValue_doc.ColumnByName('Column_Num_doc').Index] := IntToStr(i+1);
      AItem.Strings[ListValue_doc.ColumnByName('Column_A1_doc').Index] := DocTitle.Date;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A3_doc').Index] := DocTitle.Title;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index] := DocTitle.RtfPath;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A5_doc').Index] :=I2SDocType(DocTitle.DocType);
      AItem.Strings[ListValue_doc.ColumnByName('Column_A6_doc').Index] :=I2SStrikeType(DocTitle.StrikeType);
    End;
    ListValue_doc.Refresh;
  except

  end;

end;
//CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
//*************************************************************************
function TACBStopConvFrm.ReadDoclst(aID: String; var aDocLst:TList): Boolean;
var
  DocTitle :PDocTitle;
  DocLst:TStringList;
  i,j,index :integer;
  Str,aRtf,aDate,aTitle,Str2:String;
  FileName,Date:string; //添加新变量
  aDocType,aStrikeType:byte;
begin
   result :=false;
  try
    DocLst := TStringList.Create;
  //CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
  //----------------------------------加载个股公告列表
    if FAppParam.IsTwSys then
    begin
      FileName:=AMainFrm.ReadNewDoc('DOC_'+aID+'.TXT');
    end else
      FileName:=AMainFrm.ReadNewDoc(aID+'_DOCLST.dat');//add by leon 080617
    DocLst.LoadFromFile(FileName);
 //-----------------------------------加载个股公告列表

    if FAppParam.IsTwSys then
    begin
      j:=0;
      for i:=0 to DocLst.Count-2 do
      Begin
        Str:=DocLst.Strings[i];
        if (Pos('<ID=',Str)=1) then
        begin
           if (i+3<DocLst.Count) and
              SameText(DocLst.Strings[i+1],'<Title>')  Then
           begin
             Str2:=DocLst.Strings[i+2];
             new(DocTitle);
             inc(j);
             GetTitle3(j,aID,Str,Str2,DocTitle);
             aDocLst.Add(DocTitle);
           end;
           continue;
        end;
      End;
    end else
    begin
        index := Pos('['+aID+']',DocLst.Text);
        if index>0 Then
        Begin
          index := index+Length('['+aID+']');
          DocLst.Text:=Copy(DocLst.text,index+1,Length(DocLst.text)-index);
        End Else
          DocLst.Clear;
         //CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
          //---------------------加载七日内公告-----------------------
         j:=0;
        for i:=1 to DocLst.Count-2 do
        Begin
          Str:=DocLst.Strings[i];
          if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
              Break;
          if GetRtf_Date_Title3(Str,aRtf,aDate,aTitle) then
          begin
            ReplaceSubString('-',DateSeparator,aDate);
          end;
           if (now-StrToDate(aDate)<=7) then   //判断公告日期是否在七日之内
           begin
            if Pos(',',Str)>0 Then
            Begin
              new(DocTitle);
              inc(j);
              GetTitle(j,aID,Str,DocTitle);
              aDocLst.Add(DocTitle);
            End;
           end;
        End;
    end;

  except
  end;

end;
//**************************************************************************
function TACBStopConvFrm.GetTitle(aindex:integer;aID,aStr: String; var aDocTitle: PDocTitle): Boolean;
var aRtf,aDate,aTitle,aTxtFile:string; aDocType,aStrikeType:byte;
begin
  result :=false;
  try
    if(Length(aStr)=0)then exit;
    aDocTitle^.ID:=aID;
    aDocTitle^.Index:=aindex;
    if GetRtf_Date_Title5(aStr,aRtf,aDate,aTitle) then
    begin
      aDocTitle^.Date:=aDate;
      aDocTitle^.Title:=aTitle;
      aRtf:=ChangeFileExt(aRtf,'.txt');
      aDocTitle^.RtfPath:=aRtf;
    end;
  except
  end;
end;

function TStopConvInfoMgr.GetStopConvFileName: String;
var
  Strfilename:String;
begin
  Result :='';
try
  Strfilename:=GetWinTempPath+Get_GUID8+'.dat';
  if _SaveSecStopConvFile(FRecLst,PChar(Strfilename)) then
    result:=Strfilename;
except

end;

end;

procedure TStopConvInfoMgr.Setbesave;
begin
   FNeedSaveUpload := True;
end;

procedure TACBStopConvFrm.ListValue_docDblClick(Sender: TObject);
Var
  i : Integer;
  AItem,AItem1 : TdxTreeListNode;
  DocTitle :PDocTitle;
begin

   ListValue_doc.BeginUpdate;
Try

   for i:=0 to ListValue_doc.Count-1 Do
   Begin
       AItem := ListValue_doc.Items[i];
       AItem.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'false';
   End;

   AItem := ListValue_doc.FocusedNode;
   if Assigned(AItem) Then
   Begin
       AItem.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'true';
       {With ACBStopDocInfoMgr.FNowIDDocLst[AItem.Index] Do
       Begin
          AStopDocInfo.DocFileName := FileName;
          AStopDocInfo.DocTitle := ACaption;
          AStopDocInfo.DocDate := ADate;
       End; }
       AItem1 := ListValue.FocusedNode;
       if Assigned(AItem1) Then
       Begin
         {DocTitle:=FDocLst[AItem.Index];
         DateLst[AItem1.Index].DOC_FILENAME:=DocTitle.RtfPath;
         AStopConvInfoMgr.SaveStopConvDate(List_ID.Items[List_ID.ItemIndex],DateLst);  }
         AItem1.Strings[ListValue.ColumnByName('Column_A3').Index] := AItem.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index];
         SaveStopConvData(nowindex); //--Doc3.2.0需求2 huangcq080926 add
         WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
       End;
   End;
Finally
   ListValue_doc.EndUpdate;
   ListValue_doc.Repaint;
End;

end;

procedure TACBStopConvFrm.ListValueClick(Sender: TObject);
Var
  i : Integer;
  AItem,AItem1 : TdxTreeListNode;
  DocTitle :PDocTitle;
  FileName :String;
begin

   ListValue_doc.BeginUpdate;
Try
   AItem1 := ListValue.FocusedNode;
   if Assigned(AItem1) Then
   Begin
     //DocTitle:=FDocLst[AItem1.Index];
     FileName:=AItem1.Strings[ListValue.ColumnByName('Column_A3').Index];
   End;

   for i:=0 to ListValue_doc.Count-1 Do
   Begin
       AItem := ListValue_doc.Items[i];
       if(AItem.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index]=FileName)then
       begin
         AItem.Focused  := True;
         AItem.Selected := True;
         AItem.Strings[ListValue_doc.ColumnByName('Column_Chk').Index]:= 'true';
         //ListValue_doc :=AItem;
       end
       else
         AItem.Strings[ListValue_doc.ColumnByName('Column_Chk').Index]:= 'false';
   End;

Finally
   ListValue_doc.EndUpdate;
   ListValue_doc.Repaint;
End;

end;

procedure TACBStopConvFrm.RefID;
begin
try
  if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      //ShowLoadDocData;
      List_IDClick(nil);
   End;
except
end;
end;
//CBStopConvFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-新增
//*****************************************************************
procedure TACBStopConvFrm.btnAddAlldocClick(Sender: TObject);
var
  DocTitle,DocTitle2 :PAllDocTitle; //完善公告可勾选功能20080328 modify by cody
  DocLst:TStringList;
  i,j,index:integer;
  Str,Str2:String;
  FileName,aID:string;
  DocTemp,aDocLst:TList;
  AItem : TdxTreeListNode;
  AStopConvInfoMgr:TStopConvInfoMgr;
  TempfileName:string;
begin
 // result :=false;
  try
    DocLst := TStringList.Create;
    aDocLst:=TList.Create;
  //----------------------------------加载个股公告列表
    aID:=List_ID.Items[List_ID.ItemIndex]; //获取显示列表代码
//--------------------------------------------------------------------CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add
  if FAppParam.IsTwSys then
  begin
    FileName:=GetWinTempPath+'DOC_'+aID+'.txt';
  end
  else begin
    if not CheckStkCode(aID) then
    begin
      showmessage(FAppParam.ConvertString('系统中未查到与该代码对应的股票代码。'));
      exit;      
    end;
    if aID='' then
    begin
      showmessage(FAppParam.ConvertString('系统中查询该代码对应的股票代码为空，请联系系统管理人员。'));
      exit;
    end;
    FileName:=GetWinTempPath+aID+'_DOCLST.dat';  //modify by leon 080619
  end;
//--------------------------------------------------------------------------

    DocLst.LoadFromFile(FileName);
 //-----------------------------------加载个股公告列表
    TempfileName:=GetWinTempPath+'cbstopconv.dat';
    AStopConvInfoMgr:=TStopConvInfoMgr.Create(TempfileName);

    if FAppParam.IsTwSys then
    begin
      j:=0;
      for i:=0 to DocLst.Count-2 do
      Begin
        Str:=DocLst.Strings[i];
        if (Pos('<ID=',Str)=1) then
        begin
           if (i+3<DocLst.Count) and
              SameText(DocLst.Strings[i+1],'<Title>')  Then
           begin
             Str2:=DocLst.Strings[i+2];
             new(DocTitle);
             inc(j);
             GetTitle33(j,aID,Str,Str2,DocTitle);
             aDocLst.Add(DocTitle);
           end;
           continue;;
        end;
      End;
    end
    else begin
        index := Pos('['+aID+']',DocLst.Text);
        if index>0 Then
        Begin
          index := index+Length('['+aID+']');
          DocLst.Text:=Copy(DocLst.text,index+1,Length(DocLst.text)-index);
        End Else
          DocLst.Clear;
        j:=0;
        for i:=1 to DocLst.Count-2 do
        Begin
          Str:=DocLst.Strings[i];
          if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
              Break;
          if Pos(',',Str)>0 Then
          Begin
            new(DocTitle);
            inc(j);
            GetTitle2(j,aID,Str,DocTitle); //完善公告可勾选功能20080328 modify by cody
            aDocLst.Add(DocTitle);
          End;
        End;
    end;
  except
  end;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%界面公告显示
  ListValue_doc.BeginUpdate;
  try
    new(DocTitle);
    ListValue_doc.ClearNodes;
    ListValue_doc.Refresh;
    For i:=0 To aDocLst.Count-1 Do
    Begin
     // DocTitle := aDocLst[i];
//------------------------------ 公告按时间降序排列
      for j:=i+1 to aDocLst.Count-1 do
      begin
        DocTitle := aDocLst[i];
        DocTitle2:=aDocLst[j];
        if DocTitle.Date<DocTitle2.date then
        begin
         DocTemp:=aDocLst[i];
         aDocLst[i]:=aDocLst[j];
         aDocLst[j]:=DocTemp;
        end;
      end;
        DocTitle := aDocLst[i];
//-------------------------
      AItem := ListValue_doc.Add;
      AItem.Strings[ListValue_doc.ColumnByName('Column_Num_doc').Index] := IntToStr(i+1);
      AItem.Strings[ListValue_doc.ColumnByName('Column_A1_doc').Index] := DocTitle.Date;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A3_doc').Index] := DocTitle.Title;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index] := DocTitle.RtfPath;
      AItem.Strings[ListValue_doc.ColumnByName('Column_A5_doc').Index] :=I2SDocType(DocTitle.DocType);
      AItem.Strings[ListValue_doc.ColumnByName('Column_A6_doc').Index] :=I2SStrikeType(DocTitle.StrikeType);
    End;
    ListValue_doc.Refresh;
  finally
    ListValue_doc.EndUpdate;
  end;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%界面公告显示
end;
//******************************************************************************

function TACBStopConvFrm.GetTitle2(aindex: integer; aID, aStr: String;
  var aDocTitle: PAllDocTitle): Boolean;
var aRtf,aDate,aTitle,aTxtFile:string; aDocType,aStrikeType:byte;
begin
  result :=false;
  try
    if(Length(aStr)=0)then exit;
    aDocTitle^.ID:=aID;
    aDocTitle^.Index:=aindex;
    if GetRtf_Date_Title5(aStr,aRtf,aDate,aTitle) then
    begin
      aDocTitle^.Date:=aDate;
      aDocTitle^.Title:=aTitle;
      aRtf:=ChangeFileExt(aRtf,'.txt');
      aDocTitle^.RtfPath:=aRtf;
    end;
  except

  end
end;

function TACBStopConvFrm.GetTitle3(aindex: integer; aID, aStr,aStr2: String;var aDocTitle:PDocTitle): Boolean;
var aRtf,aDate,aTitle,aTxtFile:string;aDocType,aStrikeType:byte;
begin
  result :=false;
  try
    if(Length(aStr)=0)then exit;
    aDocTitle^.ID:=aID;
    aDocTitle^.Index:=aindex;
    if GetRtf_Date_Title4(aStr,aStr2,aRtf,aDate,aTitle,aDocType,aStrikeType) then
    begin
      aDocTitle^.Date:=aDate;
      aDocTitle^.Title:=aTitle;
      aDocTitle^.RtfPath:=aRtf;
      aDocTitle^.DocType:=aDocType;
      aDocTitle^.StrikeType:=aStrikeType;
    end;
  except

  end
end;

function TACBStopConvFrm.GetTitle33(aindex: integer; aID, aStr,aStr2: String;
  var aDocTitle:PAllDocTitle): Boolean;
var aRtf,aDate,aTitle,aTxtFile:string;aDocType,aStrikeType:byte;
begin
  result :=false;
  try
    if(Length(aStr)=0)then exit;
    aDocTitle^.ID:=aID;
    aDocTitle^.Index:=aindex;
    if GetRtf_Date_Title4(aStr,aStr2,aRtf,aDate,aTitle,aDocType,aStrikeType) then
    begin
      aDocTitle^.Date:=aDate;
      aDocTitle^.Title:=aTitle;
      aDocTitle^.RtfPath:=aRtf;
      aDocTitle^.DocType:=aDocType;
      aDocTitle^.StrikeType:=aStrikeType;
    end;
  except

  end
end;


/////////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//查询ID的StockCode；如果ID不存在于FCodeLst中，则为false;
/////////////////////////////////////////////////////////////////////////////////
function TACBStopConvFrm.CheckStkCode(var AID:String):Boolean;
Var
  i:integer;
  TreadCodeStr,StockCodeStr:string;
  ACodeList:PCodeList;
begin
try
  result:=false;
  for i:=0 to FCodeLst.Count do
    begin
      ACodeList:= FCodeLst.Items[i];
      TreadCodeStr:= ACodeList.TradeCode;
      StockCodeStr:= ACodeList.StkCode;
      if TreadCodeStr=AID then
        begin
          AID := StockCodeStr;
          result:= true;
          break;
        end;
    end;
except
end;
end;


/////////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//将全部tr1db中txt的每个项目的id的TradeCode与StkCode的值放入链表中
/////////////////////////////////////////////////////////////////////////////////
function TACBStopConvFrm.ReadCodetoList:Boolean;
var
  TreadCodeStr,StockCodeStr,str:String;
  FileLst : _CstrLst;
  f : TStringList;
  CodeCount:integer;
  i,j,k:integer;
  ACodeList:PCodeList;
  inifile:Tinifile;
  SectionName:String;
begin
try
  result:=false;
  FileLst:= FFileLst;
  TreadCodeStr := '';
  For i:=0 to High(fileLst) do
    Begin
      if FileExists(fileLst[i]) Then
        Begin
          CodeCount:=0;
          f := TStringList.Create;
          try
            inifile:=TiniFile.Create(fileLst[i]);
            inifile.ReadSections(f);
          finally
            inifile.Free;
          end;
          CodeCount:=f.Count;
            for k:=0 to CodeCount-1 do
              begin
                SectionName:=f.Strings[k];
                if Pos('BASE',UpperCase(SectionName))>0 then   //by leon 080901
                  begin
                    TreadCodeStr:=ReadTreadCode(FileLst[i],SectionName);
                    StockCodeStr:=ReadStockCode(FileLst[i],SectionName);
                  end;
                if TreadCodeStr<>'' then
                  begin
                    new(ACodeList);
                    ACodeList.TradeCode:=TreadCodeStr;
                    ACodeList.StkCode:=StockCodeStr;
                    FCodeLst.Add(ACodeList);
                  end;
              end;
        end;
    end;
    result:=true;
except
end;
end;

///////////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//从.txt文件中读取每个项目的 TradeCode的值；
//////////////////////////////////////////////////////////////////////////////////
function TACBStopConvFrm.ReadTreadCode(FileName:string;index:string):string;
var
 iniFile : TiniFile;
begin
try
  iniFile:=TiniFile.Create(FileName);
  result:=inifile.ReadString(index,'TradeCode','');    //
  inifile.Free;
except
end;
end;

///////////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//从.txt文件中读取每个项目的 StkCode的值；
//////////////////////////////////////////////////////////////////////////////////
function TACBStopConvFrm.ReadStockCode(FileName:string;index:string):string;
var
 iniFile : TiniFile;
begin
try
  iniFile:=TiniFile.Create(FileName);
  result:=inifile.ReadString(index,'StkCode','');
  inifile.Free;
except
end;
end;

///////////////////////////////////////////////////////////////////////////////////
////CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//传送服务器中tr1db下的market_db与public_db的.txt文件；
//////////////////////////////////////////////////////////////////////////////////
function  TACBStopConvFrm.DownDBdata():_CstrLst;
Var
  FileLst : _CstrLst;
  FilePath : String;
begin
    FilePath := GetWinTempPath + 'DB_DATA\';
    MkDir_Directory(FilePath);
    AMainFrm.ReadNewDoc2('guapai.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('passaway.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('shanggui.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('shangshi.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('nifaxing.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('pass.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('song.txt','DB_DATA');
    AMainFrm.ReadNewDoc2('stopissue.txt','DB_DATA');
    FolderAllFiles(FilePath,'.TXT',FileLst);
    result:=FileLst;
    //AMainFrm.ReadNewDoc('shenbaoset.dat');
end;

function TACBStopConvFrm.I2SDocType(i: integer): string;
begin
  result:='NONE';
  if (i-1>=0) and (i-1<FDocTypeList.Count) then
    Result:=FDocTypeList[i-1];
end;

function TACBStopConvFrm.I2SStrikeType(i: integer): string;
begin
  result:='NONE';
  if (i-1>=0) and (i-1<FStrikeTypeList.Count) then
    Result:=FStrikeTypeList[i-1];
end;


end.
