//--DOC4.0.0—N003 huangcq090209 add 原因维护
unit CBStike2Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr, dxTLClms;

type

  TAStrike2Info=Record
    InterestDate: TDate;  //除权(息)交易日  DOC4.4.0.0 add by pqx 20120207
    ADate : TDate;
    Value : Double;
    DOC_FILENAME    : String[50]; //公告文件名称
    Memo  : String;
  End;

  TACBStrike2Info=Record
     lowreset  : Double;
     HolderLst : Array of TAStrike2Info;
  End;
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

  TCBStrike2InfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBStrike2Info: TACBStrike2Info;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    procedure SortInfoDate();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBStrike2Info(const Value: TACBStrike2Info);
    Function DateStrToDate(Str:String):TDate;
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    Function GetMemoText():String;
    Function GetReasonText():String; //--DOC4.0.0—N003 huangcq090209 add
    Function GetContentWithIndex(IndexStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
    Function GetIndexWithContent(ContentStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBStrike2Info : TACBStrike2Info read FACBStrike2Info write SetACBStrike2Info;
  End;

  TACBStike2Frm = class(TFrame)
    Panel_Left: TPanel;
    Panel_Right: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel4: TPanel;
    Panel2: TPanel;
    ListValue: TdxTreeList;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A2: TdxTreeListColumn;
    Panel_NowID: TPanel;
    Bevel5: TBevel;
    Btn_Refresh: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Insert: TSpeedButton;
    Btn_MoveUp: TSpeedButton;
    Btn_MoveDwn: TSpeedButton;
    Panel3: TPanel;
    Txt_LowReset: TEdit;
    Btn_Add: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    Btn_Strik2Reason: TSpeedButton;
    Column_A3: TdxTreeListMRUColumn;
    Column_A4: TdxTreeListColumn;
    ListValue_doc: TdxTreeList;
    Column_Num_doc: TdxTreeListColumn;
    Column_Chk: TdxTreeListCheckColumn;
    Column_A5_doc: TdxTreeListColumn;
    Column_A6_doc: TdxTreeListColumn;
    Column_A1_doc: TdxTreeListColumn;
    Column_A3_doc: TdxTreeListColumn;
    Column_A4_doc: TdxTreeListColumn;
    chkV: TCheckBox;
    btnAddAlldoc: TSpeedButton;
    Column_A8: TdxTreeListColumn;
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
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_InsertClick(Sender: TObject);
    procedure Btn_MoveUpClick(Sender: TObject);
    procedure Btn_MoveDwnClick(Sender: TObject);
    procedure Txt_LowResetChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure Txt_LowResetExit(Sender: TObject);
    procedure ListValueEditChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Btn_Strik2ReasonClick(Sender: TObject);
    procedure Column_A3ButtonClick(Sender: TObject);
    procedure Column_A3Change(Sender: TObject);
    procedure chkVClick(Sender: TObject);
    procedure btnAddAlldocClick(Sender: TObject);
    procedure ListValue_docDblClick(Sender: TObject);
    procedure ListValueClick(Sender: TObject);
  private
    { Private declarations }
    ACBStrike2InfoMgr : TCBStrike2InfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    FDocTypeList,FStrikeTypeList:TStringList;
    
    nowindex:integer;
    FDocLst :TList;
    FDocLstFile :String;
    
    Procedure ResetNum();
    Procedure DeleteAData();
    Procedure InsertAData();
    Procedure AddAData();
    Procedure MoveUp();
    Procedure MoveDwn();
    procedure RefreshReasonDropItem(ReasonStr:String); //--DOC4.0.0—N003 huangcq090209 add
    procedure Init(Const FileName:String);

  public
    { Public declarations }
    function SaveDocData():boolean;
    Procedure LoadDocData();
    Procedure ShowLoadDocData();
    Procedure SetInit(Parent:TWinControl;Const FileName:String);
    Function GetMemoText():String;
    Procedure Refresh(Const FileName:String);
    Function NeedSave():Boolean;
    Procedure BeSave();
    procedure RefID();
    function GetTitle2(aindex: integer; aID, aStr: String;
        var aDocTitle: PAllDocTitle): Boolean;
    function GetTitle3(aindex: integer; aID,aStr,aStr2: String;
        var aDocTitle: PAllDocTitle): Boolean;
    function I2SDocType(i:integer):string;
    function I2SStrikeType(i:integer):string;
    function DownDBdata2():boolean;
  end;


implementation
uses
  MainFrm,ReasonEditFrm;

{$R *.dfm}

{ TACBDocFrm }

procedure TACBStike2Frm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;
   chkV.Caption:=FAppParam.ConvertString('显示公告列表');
   ListValue.ClearNodes;

   if Not Assigned(ACBStrike2InfoMgr) Then
     ACBStrike2InfoMgr := TCBStrike2InfoMgr.Create(FileName);

   BeSave;

   Txt_LowReset.Text := '0';

   List_ID.Clear;
   For i:=0 to ACBStrike2InfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBStrike2InfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;
   {** //--DOC4.0.0—N003 huangcq090209 del
   Column_A3.Items.Clear;
   Column_A3.Items.Add(FAppParam.ConvertString('初始转股价格'));
   Column_A3.Items.Add(FAppParam.ConvertString('除权除息调整'));
   Column_A3.Items.Add(FAppParam.ConvertString('向下修正转股价格'));
   **}
   RefreshReasonDropItem(ACBStrike2InfoMgr.GetReasonText);//--DOC4.0.0—N003 huangcq090209 add
   
end;

procedure TACBStike2Frm.RefreshReasonDropItem(ReasonStr:String); //--DOC4.0.0—N003 huangcq090209 add
begin
  ListValue.BeginUpdate;
  Column_A3.Items.Clear;
  Column_A3.Items.Text:=ReasonStr;
  ListValue.EndUpdate;
end;

procedure TACBStike2Frm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBStrike2InfoMgr.ReadDocDat(ID);
end;

procedure TACBStike2Frm.SetInit(Parent: TWinControl;Const FileName:String);
var sFile,sLine:string;
    fini:TiniFile;
    i,iCount:integer;
begin
    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Panel3.Caption := FAppParam.ConvertString('修正空间:');

    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');
    Btn_Delete.Caption  := FAppParam.ConvertString('>>删除');
    Btn_Insert.Caption  := FAppParam.ConvertString('>>插入');
    Btn_Add.Caption  := FAppParam.ConvertString('>>新增');
    Btn_MoveUp.Caption  := FAppParam.ConvertString('>>上移');
    Btn_MoveDwn.Caption  := FAppParam.ConvertString('>>下移');
    Btn_Strik2Reason.Caption := FAppParam.ConvertString('>>转股原因');//--DOC4.0.0—N003 huangcq090209 add

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    //-----------DOC4.4.0.0   pqx 20120207
    ListValue.Columns[1].Caption := FAppParam.ConvertString('除权（息）交易日');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('价格调整日');
    //---
    ListValue.Columns[3].Caption := FAppParam.ConvertString('转股价格');
    ListValue.Columns[4].Caption := FAppParam.ConvertString('转股原因');

    ListValue_doc.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue_doc.Columns[1].Caption := FAppParam.ConvertString('勾选');
    Column_A5_doc.Caption := FAppParam.ConvertString('公告类型');
    Column_A6_doc.Caption := FAppParam.ConvertString('种类');
    Column_A1_doc.Caption := FAppParam.ConvertString('日期');
    Column_A3_doc.Caption := FAppParam.ConvertString('公告');
    btnAddAlldoc.Caption := FAppParam.ConvertString('加载全部公告');

    Self.Parent := Parent;
    Self.Align := alClient;

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

    Init(FileName);


end;

procedure TACBStike2Frm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin

    FLockMemoChange := True;
Try

   ListValue.ClearNodes;

   Txt_LowReset.Text:=  FloatToStr(ACBStrike2InfoMgr.ACBStrike2Info.lowreset);

   For i:=0 to High(ACBStrike2InfoMgr.ACBStrike2Info.HolderLst) do
   Begin
     AItem :=  ListValue.Add;
     With  ACBStrike2InfoMgr.ACBStrike2Info Do
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
       //--DOC4.4.0.0 pqx 20120207
       AItem.Strings[ListValue.ColumnByName('Column_A4').Index] := FormatDateTime('yyyy-mm-dd',HolderLst[i].InterestDate);
       //--
       AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FormatDateTime('yyyy-mm-dd',HolderLst[i].ADate);
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := FloatToStr(HolderLst[i].Value);
       //AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := HolderLst[i].Memo;
       AItem.Strings[ListValue.ColumnByName('Column_A3').Index] :=
                                ACBStrike2InfoMgr.GetContentWithIndex(HolderLst[i].Memo); //--DOC4.0.0—N003 huangcq090209 add
       AItem.Strings[ListValue.ColumnByName('Column_A8').Index] :=
                                HolderLst[i].DOC_FILENAME;
     End;
   End;


Finally
   FLockMemoChange := false;
End;

end;

function TACBStike2Frm.SaveDocData:boolean;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  AStrike2Info  : TACBStrike2Info;
  BaseDate,InterestDate : TDate;
  Str : String;
begin

Try

   AStrike2Info  := ACBStrike2InfoMgr.ACBStrike2Info;
   Result:=false;

   Str := Trim(Txt_LowReset.Text);
   if Length(Str)=0 Then
       Str := '0';
   AStrike2Info.lowreset := StrToFloat(Str);

   SetLength(AStrike2Info.HolderLst,ListValue.Count);
   For i:=0 to High(AStrike2Info.HolderLst) do
   Begin
     AItem :=  ListValue.Items[i];
     //--DOC4.4.0.0   pqx 20120207--------------------------------------------
     InterestDate := -1;
     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A4').Index]);
     if Length(Str)>0 Then
     Begin
        if Not IsDate(Str) Then
           Raise Exception.Create(FAppParam.ConvertString('除权（息）交易日输入错误'));
        InterestDate := StrToDate2(Str);
     End;
     //----------------------------------------------------------------------
     BaseDate := -1;
     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
     if Length(Str)>0 Then
     Begin
        if Not IsDate(Str) Then
           //Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
           Raise Exception.Create(FAppParam.ConvertString('价格调整日期输入错误')); //--DOC4.4.0.0   pqx 20120207
        BaseDate := StrToDate2(Str);
     End;

     Str := AItem.Strings[ListValue.ColumnByName('Column_A2').Index];
     if Length(Str)=0 Then
        Str := '0';
     Str := ReplaceNumString(Str);
     if Not isInteger(PChar(Str)) Then
        Raise Exception.Create(FAppParam.ConvertString(Format('转股价格：[%s]不是一个合法的数值.', [Str]))); //--DOC4.4.0.0   pqx 20120207

     With  AStrike2Info Do
     Begin
        HolderLst[i].ADate := BaseDate;
        HolderLst[i].InterestDate := InterestDate;
        HolderLst[i].Value := StrToFloat(ReplaceNumString(Str));
        Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A3').Index]);
        if Length(Str)=0 Then
            Str := 'na';
        //HolderLst[i].Memo  := Str;
        HolderLst[i].Memo  := ACBStrike2InfoMgr.GetIndexWithContent(Str);//--DOC4.0.0—N003 huangcq090209 add
        Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A8').Index]);
        if Length(Str)=0 Then
            Str := 'NONE';
        HolderLst[i].DOC_FILENAME :=Str;
     End;
   End;

    ACBStrike2InfoMgr.ACBStrike2Info := AStrike2Info;

    FHaveChangeData := false;
    Result:=true;
Finally
End;

end;

function TACBStike2Frm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ACBStrike2InfoMgr) Then
     Result := ACBStrike2InfoMgr.GetMemoText;
  ShowLoadDocData;
end;

{ TCBStrike2InfoMgr }

constructor TCBStrike2InfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBStrike2InfoMgr.CreateAID(var ID: String): Boolean;
Var
  i : Integer;
begin

   Result := False;
   if Not NewAID(ID) Then
      Exit;

   For i:=0 to High(FIDLst) do
   Begin
      if FIDLst[i]=ID Then
      Begin
         ShowMessage(FAppParam.ConvertString('代码已存在.'));
         Exit;
      End;
   End;

   i := High(FIDLst)+1;
   SetLength(FIDLst,i+1);
   FIDLst[i] := ID;

   ReadDocDat(ID);

   Result := True;


end;

function TCBStrike2InfoMgr.DateStrToDate(Str: String): TDate;
begin
    Result := -1;
    if Length(Str)<8 Then
      Exit;
    Str := Copy(Str,1,4)+'-'+Copy(Str,5,2)+'-'+Copy(Str,7,2);
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
    Result := StrToDate2(Str);
end;

function TCBStrike2InfoMgr.DelAID(): Boolean;
Var
  i,j : Integer;
  f : TIniFile;
  ID : String;
begin

   Result := False;
   f := nil;

Try
Try
   ID := FNowID;

   For i:=0 to High(FIDLst) do
   Begin
      if FIDLst[i]=ID Then
      Begin
         for j:=i to High(FIDLst)-1 do
           FIDLst[j] := FIDLst[j+1];
        SetLength(FIDLst,High(FIDLst));
        f := TIniFile.Create(FFileName);
        f.EraseSection(ID);
        FNowID := '';
        FNeedSave := False;
        FNeedSaveUpload := True;
        Result := True;
      End;
   End;

Except
End;
Finally
     f.Free;
End;


end;

destructor TCBStrike2InfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBStrike2InfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBStrike2InfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

Function TCBStrike2InfoMgr.GetReasonText():String; //--DOC4.0.0—N003 huangcq090209 add
var
  AReasonLst:TStringList;
  AF:TIniFile;
  AIndex,i:integer;
begin
  Result:='';
  try
    AReasonLst:=TStringList.Create;
    AF:=TIniFile.Create(FFileName);
    AF.ReadSectionValues('ReasonList',AReasonLst);
    if AReasonLst.Count<=0 then exit;
    For i:=0 to AReasonLst.Count-1 do
    begin
      With AReasonLst do
      begin
        AIndex:=Pos('=',Strings[i]);
        if AIndex>0 then
          Strings[i]:=Copy(Strings[i],AIndex+1,Length(Strings[i])-AIndex);
      end;
    end;
    Result:=AReasonLst.Text;
  finally
    AReasonLst.Free;
    AF.Free;
  end;
end;

Function TCBStrike2InfoMgr.GetContentWithIndex(IndexStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
var
  AF:TIniFile;
begin
  try
    Result := '';
    AF := TIniFile.Create(FFileName);
    Result := AF.ReadString('ReasonList',IndexStr,'na');
  finally
    if Assigned(AF) then AF.Free;
  end;
end;

Function TCBStrike2InfoMgr.GetIndexWithContent(ContentStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
var
  AF:TIniFile;
  ValueLst:TStringList;
begin
  try
    Result := 'na';
    AF := TIniFile.Create(FFileName);
    ValueLst := TStringList.Create;
    AF.ReadSectionValues('ReasonList',ValueLst); //name=value
    while (ValueLst.Count >0) do
    begin
      if UpperCase(Trim(ValueLst.Values[ValueLst.Names[0]])) = UpperCase(ContentStr) then
      begin
        Result := ValueLst.Names[0];
        Break;
      end;
      ValueLst.Delete(0);
    end;
  finally
    if Assigned(AF) then AF.Free;
    if Assigned(ValueLst) then ValueLst.Free;
  end;
end;

function TCBStrike2InfoMgr.GetMemoText: String;
begin
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

procedure TCBStrike2InfoMgr.Init;
Var
  i,j : Integer;
  Str : String;
begin

try
try

   FNeedSave := False;

   FFileMemo.LoadFromFile(FFileName);

   SetLength(FIDLst,0);

   For i:=0 to FFileMemo.Count-1 do
   Begin
       if (Pos('[',FFileMemo.Strings[i])>0) and
          (Pos(']',FFileMemo.Strings[i])>0) Then
       Begin
           Str := Trim(FFileMemo.Strings[i]);
           ReplaceSubString('[','',Str);
           ReplaceSubString(']','',Str);

           if (UpperCase(Str)='GUID') or (UpperCase(Str)='REASONLIST') then //--DOC4.0.0—N003 huangcq090209 add 这两个不属于ID
             continue;           

           j := High(FIDLst)+1;
           SetLength(FIDLst,j+1);
           FIDLst[j] := Str;
       End;
   End;

   SortIDLst(FIDLst);


except
  On E:Exception Do
  Begin
     FFileMemo.Clear;
     ShowMessage(E.Message);
  End;
End;

Finally
End;


end;



procedure TCBStrike2InfoMgr.ReadDocDat(const ID: String);
Var
  f : TIniFile;
  Str : String;
  StrLst:_CStrLst2;
  Count,i : integer;
  StrMaxIndex: Integer;  //---DOC4.4.0.0 add by pqx 20120207-----
Begin

  SaveDocDat;

  SetLength(StrLst,0);


  f := TIniFile.Create(FFileName);


  FNowID := ID;

  Try
  Try

  Count := f.ReadInteger(ID,'Count',0);


  FACBStrike2Info.lowreset := f.ReadFloat(ID,'lowreset',0);

  SetLength(FACBStrike2Info.HolderLst,0);

  if Count=0 Then
  Begin
    SetLength(FACBStrike2Info.HolderLst,Count);
    i := 0;
    While True Do
    Begin
       Str := f.ReadString(ID,IntToStr(i+1),'');
       if Length(Str)=0 Then
         Break;
       StrLst := DoStrArray2(Str,',');
       StrMaxIndex := High(StrLst);  //---DOC4.4.0.0 add by pqx 20120207-----
       //if High(StrLst)=2 Then
       if StrMaxIndex>=2 Then //---DOC4.4.0.0 add by pqx 20120207-----
       Begin
         Count := High(FACBStrike2Info.HolderLst)+1;
         SetLength(FACBStrike2Info.HolderLst,Count+1);
         FACBStrike2Info.HolderLst[Count].ADate := DateStrToDate(StrLst[0]);
         FACBStrike2Info.HolderLst[Count].Value := StrToFloat(StrLst[1]);
         FACBStrike2Info.HolderLst[Count].Memo := StrLst[2];
         //---DOC4.4.0.0 add by pqx 20120207----
         if StrMaxIndex = 3 then
           FACBStrike2Info.HolderLst[Count].InterestDate := DateStrToDate(StrLst[3])
         else
           FACBStrike2Info.HolderLst[Count].InterestDate := 0;
         //--------------------------------------
       End;
       inc(i);
    End;
  End Else
  Begin
    SetLength(FACBStrike2Info.HolderLst,Count);
    For i:=0 to High(FACBStrike2Info.HolderLst) Do
    Begin
       Str := f.ReadString(ID,IntToStr(i+1),'');
       StrLst := DoStrArray2(Str,',');
       StrMaxIndex := High(StrLst);  //---DOC4.4.0.0 add by pqx 20120207
       //if High(StrLst)=2 Then
       if StrMaxIndex>=2 Then //---DOC4.4.0.0 add by pqx 20120207
       Begin
         FACBStrike2Info.HolderLst[i].ADate := DateStrToDate(StrLst[0]);
         FACBStrike2Info.HolderLst[i].Value := StrToFloat(StrLst[1]);
         FACBStrike2Info.HolderLst[i].Memo := StrLst[2];
         //---DOC4.4.0.0 add by pqx 20120207-----
         if StrMaxIndex >= 3 then
           FACBStrike2Info.HolderLst[i].InterestDate := DateStrToDate(StrLst[3])
         else
           FACBStrike2Info.HolderLst[i].InterestDate := 0;
         if StrMaxIndex >= 4 then
           FACBStrike2Info.HolderLst[i].DOC_FILENAME := (StrLst[4])
         else
           FACBStrike2Info.HolderLst[i].DOC_FILENAME := '';
         //--------------------------------------         
       End;
    End;
  End;

  Except
  End;
  Finally
     f.Free;
  End;





end;

procedure TCBStrike2InfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBStrike2InfoMgr.SaveDocDat;
Var
  f : TIniFile;
  Str : String;
  i,c : integer;
Begin

  if Length(FNowID)=0 Then
    Exit;
  if Not FNeedSave Then
     Exit;

  SortInfoDate;   

  f := TIniFile.Create(FFileName);

  Try
  Try
  c := 0;
  f.EraseSection(FNowID);
  f.WriteInteger(FNowID,'Count',0);
  For i:=0 to High(FACBStrike2Info.HolderLst) Do
  Begin
      if FACBStrike2Info.HolderLst[i].ADate>0 Then
      Begin

        Str := Trim(FACBStrike2Info.HolderLst[i].Memo);
        ReplaceSubString(',','',Str);
        FACBStrike2Info.HolderLst[i].Memo := Str;


      {  Str := Format('%s,%s,%s',
               [formatDateTime('yyyymmdd',FACBStrike2Info.HolderLst[i].ADate),
                FloatToStr(FACBStrike2Info.HolderLst[i].Value),
                FACBStrike2Info.HolderLst[i].Memo]); }
        //---DOC4.4.0.0 add by pqx 20120207-----
        Str := Format('%s,%s,%s,%s,%s',
               [formatDateTime('yyyymmdd',FACBStrike2Info.HolderLst[i].ADate),
                FloatToStr(FACBStrike2Info.HolderLst[i].Value),
                FACBStrike2Info.HolderLst[i].Memo,
                formatDateTime('yyyymmdd',FACBStrike2Info.HolderLst[i].InterestDate),
                FACBStrike2Info.HolderLst[i].DOC_FILENAME]);
        //-----------------------------------------
        f.WriteString(FNowID,IntToStr(c+1),Str);
        inc(c);
      End;
  End;
  f.WriteInteger(FNowID,'Count',c);
  f.WriteFloat(FNowID,'lowreset',FACBStrike2Info.lowreset);


  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;

end;


procedure TACBStike2Frm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBStike2Frm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBStike2Frm.List_IDClick(Sender: TObject);
begin
  LoadDocData;
  ShowLoadDocData;
  {if SaveDocData then
  begin
     //ShowDocData;
     //nowindex:=List_ID.ItemIndex;
     //LoadDocTitle(nowindex);
  end
  else
     //List_ID.ItemIndex:=nowindex;   }
end;


procedure TCBStrike2InfoMgr.SetACBStrike2Info(
  const Value: TACBStrike2Info);
begin
  FACBStrike2Info := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBStike2Frm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  ListValue.FocusedColumn<>0;
end;

procedure TACBStike2Frm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBStike2Frm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBStike2Frm.DeleteAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;
    if Not Assigned(AItem) Then
       Exit;

   AItem.Free;

   ResetNum;

end;

procedure TACBStike2Frm.InsertAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;

    if Assigned(AItem) Then
      ListValue.Insert(AItem)
    Else
      ListValue.Add;


   ResetNum;


end;

procedure TACBStike2Frm.MoveDwn;
Var
 AItem1 : TdxTreeListNode;
 AItem2 : TdxTreeListNode;
begin
    AItem1 := ListValue.FocusedNode;
    if Not Assigned(AItem1) Then
       Exit;

    if AItem1.Index=ListValue.Count-1 Then
       Exit;

    AItem2 :=  ListValue.Items[AItem1.Index+1];

    AItem2.MoveTo(AItem1,natlInsert);
    AItem1.Focused := True;

    ResetNum;

end;

procedure TACBStike2Frm.MoveUp;
Var
 AItem1 : TdxTreeListNode;
 AItem2 : TdxTreeListNode;
begin
    AItem1 := ListValue.FocusedNode;
    if Not Assigned(AItem1) Then
       Exit;

    if AItem1.Index=0 Then
       Exit;

    AItem2 :=  ListValue.Items[AItem1.Index-1];

    Aitem1.MoveTo(AItem2,natlInsert);

    ResetNum;

end;

procedure TACBStike2Frm.ResetNum;
Var
 AItem : TdxTreeListNode;
 i : Integer;
begin
   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
   End;

end;

procedure TACBStike2Frm.Refresh(const FileName: String);
begin
   ACBStrike2InfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBStike2Frm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin
  if  ( AColumn.Index=0) Then
  Begin
      AColor := $0080FFFF;
      AFont.Color := clBlack;
  end;
end;

procedure TACBStike2Frm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBStike2Frm.Btn_DeleteClick(Sender: TObject);
begin
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  Begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
    DeleteAData;
    SaveDocData;
  End;
end;

procedure TACBStike2Frm.Btn_InsertClick(Sender: TObject);
begin
   InsertAData;
end;

procedure TACBStike2Frm.Btn_MoveUpClick(Sender: TObject);
begin
 MoveUp;
 WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
 SaveDocData;
end;

procedure TACBStike2Frm.Btn_MoveDwnClick(Sender: TObject);
begin
  MoveDwn;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
end;

procedure TACBStike2Frm.Btn_Strik2ReasonClick(Sender: TObject); //--DOC4.0.0—N003 huangcq090209 add
var
  AFileName:String;
  AShowResult:Boolean;
begin
  if not Assigned(ACBStrike2InfoMgr) then
    exit;
  try
    AFileName:=ACBStrike2InfoMgr.FFileName;
    AReasonEditFrm:=TAReasonEditFrm.Create(self);
    AShowResult:=AReasonEditFrm.ShowReasonFrm(FAppParam,RsnTypeStrike2,AFileName);
    if AShowResult then
    begin
      //原因内容有变动需上传
      ACBStrike2InfoMgr.FNeedSaveUpload := True;
      //更新下拉框的原因选择内容
      RefreshReasonDropItem(ACBStrike2InfoMgr.GetReasonText);
      List_IDClick(nil);
      //ShowLoadDocData;
    end;
  finally
    AReasonEditFrm.Free;
  end;
end;

procedure TACBStike2Frm.Column_A3ButtonClick(Sender: TObject);//--DOC4.0.0—N003 huangcq090209 add
begin
  Btn_Strik2Reason.Click;
end;

procedure TACBStike2Frm.Txt_LowResetChange(Sender: TObject);
begin
  if Not FLockMemoChange Then
     FHaveChangeData := True;
end;

procedure TACBStike2Frm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin
   if ACBStrike2InfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;
end;

procedure TACBStike2Frm.AddAData;
begin
   ListValue.Add;
   ResetNum;
end;

procedure TACBStike2Frm.Btn_AddClick(Sender: TObject);
begin
   AddAData;
end;

procedure TACBStike2Frm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBStrike2InfoMgr.DelAID() Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Del',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      ListValue.ClearNodes;

      Index := List_ID.ItemIndex;
      List_ID.Items.Delete(List_ID.ItemIndex);

      if Index>List_ID.Count-1 Then
         Index := List_ID.Count-1;
      if Index>=0 Then
      Begin
        List_ID.ItemIndex := Index;
        LoadDocData;
        ShowLoadDocData;
      End;

   End;
Finally
End;

end;

procedure TACBStike2Frm.Txt_IDChange(Sender: TObject);
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
          LoadDocData;
          ShowLoadDocData;
          Break;
        End;
      end;
      i:=i+1;
    End;
  end;
end;

function TACBStike2Frm.NeedSave: Boolean;
begin
   Result := ACBStrike2InfoMgr.FNeedSaveUpload ;
end;

procedure TACBStike2Frm.BeSave;
begin
   ACBStrike2InfoMgr.FNeedSaveUpload := False;
end;

procedure TCBStrike2InfoMgr.SortInfoDate;
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp : TAStrike2Info;
  i,Count :Integer;
Begin

  if High(FACBStrike2Info.HolderLst)<0 then exit;

  i := High(FACBStrike2Info.HolderLst)+1;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin

            lTemp  := FACBStrike2Info.HolderLst[lLoop1];
            lHold  := lLoop1;
            while FACBStrike2Info.HolderLst[lHold - lHValue].ADate > lTemp.ADate do
            Begin
                 FACBStrike2Info.HolderLst[lHold] := FACBStrike2Info.HolderLst[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            FACBStrike2Info.HolderLst[lHold] := lTemp;
        End;
  Until lHValue = 0;

end;

procedure TACBStike2Frm.Txt_LowResetExit(Sender: TObject);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBStike2Frm.ListValueEditChange(Sender: TObject);
begin
   FHaveChangeData := True;
end;

function TCBStrike2InfoMgr.UpdateAID(var ID: String): Boolean;
Var
 i : Integer;
 f : TIniFile;
begin

   Result := False;
   ID := FNowID;
   if Not ModifyAID(ID) Then
      Exit;

   For i:=0 to High(FIDLst) do
   Begin
      if FIDLst[i]=ID Then
      Begin
         ShowMessage(FAppParam.ConvertString('代码已存在.'));
         Exit;
      End;
   End;

   for i:=0 to High(FIDLst) do
     if FIDLst[i]=FNowID Then
     Begin
        f := TIniFile.Create(FFileName);
        f.EraseSection(FNowID);
        f.Free;
        FNowID := ID;
        FNeedSave := true;
        FNeedSaveUpload := True;
        SaveDocDat;
        FIDLst[i] := ID;
        Break;
     End;

   Result := True;

end;

procedure TACBStike2Frm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBStrike2InfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;
end;

procedure TACBStike2Frm.RefID;
begin
try
  if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;
except
end;
end;


procedure TACBStike2Frm.Column_A3Change(Sender: TObject);
begin
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
end;

procedure TACBStike2Frm.chkVClick(Sender: TObject);
begin
  ListValue_doc.Visible:=chkV.Checked;
end;

procedure TACBStike2Frm.btnAddAlldocClick(Sender: TObject);
var
  DocTitle,DocTitle2 :PAllDocTitle; //完善公告可勾选功能20080328 modify by cody
  DocLst:TStringList;
  i,j,index:integer;
  Str,Str2:String;
  FileName,aID:string;
  DocTemp,aDocLst:TList;
  AItem : TdxTreeListNode;
  TempfileName:string;
begin
 // result :=false;
  try
    DocLst := TStringList.Create;
    aDocLst:=TList.Create;
  //----------------------------------加载个股公告列表
    aID:=List_ID.Items[List_ID.ItemIndex]; //获取显示列表代码
    if FAppParam.IsTwSys then
    begin
      FileName:=AMainFrm.ReadNewDoc('DOC_'+aID+'.TXT');
    end else
      FileName:=AMainFrm.ReadNewDoc(aID+'_DOCLST.dat');//add by leon 080617

    if FAppParam.IsTwSys then
    begin
      //FileName:=GetWinTempPath+'shenbao'+aID+'_DOCLST.dat';
    end
    else begin
      {if not CheckStkCode(aID) then
      begin
        showmessage(FAppParam.ConvertString('系统中未查到与该代码对应的股票代码。'));
        exit;      
      end;
      if aID='' then
      begin
        showmessage(FAppParam.ConvertString('系统中查询该代码对应的股票代码为空，请联系系统管理人员。'));
        exit;
      end; }
      //FileName:=GetWinTempPath+aID+'_DOCLST.dat';  //modify by leon 080619
    end;
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

function TACBStike2Frm.GetTitle3(aindex: integer; aID,aStr,aStr2: String;
        var aDocTitle: PAllDocTitle): Boolean;
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

function TACBStike2Frm.GetTitle2(aindex: integer; aID, aStr: String;
  var aDocTitle: PAllDocTitle): Boolean;
var aRtf,aDate,aTitle,aTxtFile:string;aDocType,aStrikeType:byte;
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

function TACBStike2Frm.I2SDocType(i: integer): string;
begin
  result:='NONE';
  //showmessage('DocType:'+IntToStr(i)+#13#10+FDocTypeList.text);
  if (i-1>=0) and (i-1<FDocTypeList.Count) then
    Result:=FDocTypeList[i-1];
end;

function TACBStike2Frm.I2SStrikeType(i: integer): string;
begin
  result:='NONE';
  //showmessage('StrikeType:'+IntToStr(i)+#13#10+FStrikeTypeList.text);
  if (i-1>=0) and (i-1<FStrikeTypeList.Count) then
    Result:=FStrikeTypeList[i-1];
end;

function  TACBStike2Frm.DownDBdata2():boolean;
Var
  FilePath : String;
begin
    FilePath := GetWinTempPath ;
    //AMainFrm.ReadNewDoc('shenbaoset.dat');
    result:=True;
end;

procedure TACBStike2Frm.ListValue_docDblClick(Sender: TObject);
Var
  i : Integer;
  AItem1 : TdxTreeListNode; //AItem,
  AItemOld,AItemNew:TdxTreeListNode;
  DocTitle :PDocTitle;
begin
   ListValue_doc.BeginUpdate;
Try
   AItemNew:=ListValue_doc.FocusedNode;
   AItem1 := ListValue.FocusedNode;

   if not Assigned(AItem1) then
   begin
     ShowMessage('not Assigned(AItem1) ');
     Exit;
   end;
   if not Assigned(AItemNew) then
   begin
     ShowMessage('not Assigned(AItemNew) ');
     Exit;
   end;

   for i:=0 to ListValue_doc.Count-1 Do
   Begin
       AItemOld := ListValue_doc.Items[i];
       if (AItemOld.Strings[ListValue_doc.ColumnByName('Column_Chk').Index]='true') then
       begin
         AItemOld.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'false';
         break;
       end;
   End;

  if Assigned(AItemOld) and (AItemNew.Index=AItemOld.Index) then  //原先选择与新选择是同一条，则取消选择
    AItem1.Strings[ListValue.ColumnByName('Column_A8').Index] :=''
  else begin
    AItemNew.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'true';
    AItem1.Strings[ListValue.ColumnByName('Column_A8').Index] :=AItemNew.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index];
    showmessage(AItem1.Strings[ListValue.ColumnByName('Column_A8').Index])
  end;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
Finally
   ListValue_doc.EndUpdate;
   ListValue_doc.Repaint;
End;
end;

procedure TACBStike2Frm.ListValueClick(Sender: TObject);
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
     FileName:=AItem1.Strings[ListValue.ColumnByName('Column_A8').Index];
   End
   else begin
     ShowMessage('not Assigned(AItem1)');
   end;

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
end.
