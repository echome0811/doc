//--Doc4.0—N004 huangcq090317 add 赎回日期、卖回日期，新增了本窗体
unit CBRedeemDateFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr,TDocRW, dxTLClms,ReasonEditFrm;

type


  TARedeemSaleInfo=Record
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

  TRedeemInfoMgr=Class
  private
    FFileName : String;
    FRecLst : array of TREDEEMSALE_PERIOD_RPT;
    FDateLst: array of TREDEEMSALE_PERIOD_DETAIL;
    FNowID : String;
    FFileMemo:TStringList;
    FARedeemSaleInfo: TARedeemSaleInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    procedure Sort(Var aRecLst:Array of TREDEEMSALE_PERIOD_DETAIL);
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetARedeemSaleInfo(const Value: TARedeemSaleInfo);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure ReadRedeemSaleDate(Const ID:String);
    procedure GetRedeemSaleDate(Const ID:String;var DateLst:Array of TREDEEMSALE_PERIOD_DETAIL);
    procedure SaveRedeemSaleDate(Const ID:String;Const DateLst:Array of TREDEEMSALE_PERIOD_DETAIL);
    Function SaveRedeemSaleFile(Const ID:String;Const DateLst:Array of TREDEEMSALE_PERIOD_DETAIL):Boolean; //--DOC4.0.0—N004 huangcq090317 add

    procedure SaveDocDat();
    procedure Setbesave();
    Function UpdateAID(Var ID:String;nowID:String):Boolean;
    procedure DelDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID(ID :String):Boolean;
    Function GetMemoText():String;
    Function GetReasonText():String; //--DOC4.0.0—N003 huangcq090209 add
    Function GetContentWithIndex(IndexStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
    Function GetIndexWithContent(ContentStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
    Function GetRedeemSaleFileName:String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ARedeemSaleInfo : TARedeemSaleInfo read FARedeemSaleInfo write SetARedeemSaleInfo;
  End;
  
  TACBRedeemDateFrm = class(TFrame)
    Splitter1: TSplitter;
    Bevel2: TBevel;
    Panel_Left: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Txt_ID: TEdit;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    Panel_Right: TPanel;
    Panel2: TPanel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Bevel5: TBevel;
    Btn_Refresh: TSpeedButton;
    Splitter2: TSplitter;
    btnAddAlldoc: TSpeedButton;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A2: TdxTreeListColumn;
    Column_A3: TdxTreeListColumn;
    ListValue_doc: TdxTreeList;
    Column_Num_doc: TdxTreeListColumn;
    Column_Chk: TdxTreeListCheckColumn;
    Column_A1_doc: TdxTreeListColumn;
    Column_A3_doc: TdxTreeListColumn;
    Column_A4_doc: TdxTreeListColumn;
    Panel_NowID: TPanel;
    Column_Price: TdxTreeListColumn;
    Column_Reason: TdxTreeListMRUColumn;
    Btn_RedeemReason: TSpeedButton;
    spl1: TSplitter;
    chkV: TCheckBox;
    Column_A5_doc: TdxTreeListColumn;
    Column_A6_doc: TdxTreeListColumn;
    procedure Txt_MemoChange(Sender: TObject);
    procedure Txt_InfoChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
    procedure ListValueEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure ListValueEditChange(Sender: TObject);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure Btn_RefreshClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListValue_docDblClick(Sender: TObject);
    procedure ListValueClick(Sender: TObject);
    procedure btnAddAlldocClick(Sender: TObject);
    procedure Btn_RedeemReasonClick(Sender: TObject);
    procedure Column_ReasonButtonClick(Sender: TObject);
    procedure Column_ReasonChange(Sender: TObject);
    procedure chkVClick(Sender: TObject);
  private
    { Private declarations }
    ARedeemInfoMgr : TRedeemInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    nowindex:integer;
    FDocLst :TList;
    FDocLstFile :String;
    FIDLstFile  :String; //
    k:integer;
    DateLst:Array of TREDEEMSALE_PERIOD_DETAIL;
    Procedure CreateDefauleItem();
    procedure RefreshReasonDropItem(ReasonStr:String); //--DOC4.0.0—N003 huangcq090209 add
    function ReturnReasonTypeStr(pReasonType:ReasonType):String;
    procedure Init(Const FileName:String);
    function FreeTheDocTitleLst():Boolean;

  Protected
    {Protected declarations}
    FReasonTag:ReasonType; //放在这里是位了方便继承使用

  public
    { Public declarations }
    FCodeLst : TList;
    FFileLst : _CstrLst; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    FDocTypeList,FStrikeTypeList:TStringList;
    function  DownDBdata2():boolean;
    function SaveDocData():boolean;
    Procedure LoadDocData();
    Procedure ShowLoadDocData();
    Procedure ShowDocData();
    Procedure SaveRedeemSaleData(aindex:integer);
    procedure Sort(Var aRecLst:Array of TREDEEMSALE_PERIOD_DETAIL);
    Procedure SetInit(Parent:TWinControl;Const FileName,pIDLstFile:String);virtual; //这里加入virtual是为了CBSaleDateFrm的继承
    Function GetMemoText():String;
    Procedure Refresh(Const FileName:String);
    Function NeedSave():Boolean;
    Procedure BeSave();
    Function GetFileName:String;
    function LoadDocTitle(aindex:integer):Boolean;
    function ReadDoclst(aID:String;var aDocLst:TList):Boolean;
    Function GetTitle(aindex:integer;aID,aStr:String;var aDocTitle:PDocTitle):Boolean;
    Function GetTitle2(aindex:integer;aID,aStr:String;var aDocTitle:PAllDocTitle):Boolean; //完善公告可勾选功能20080328 add
    function GetTitle3(aindex: integer; aID, aStr,aStr2: String;var aDocTitle: PDocTitle): Boolean;
    procedure RefID();
    function CheckStkCode(var AID:String):boolean;   //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  DownDBdata(Const pDwnMemo:Integer):_CstrLst;            //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadTreadCode(FileName:string;index:string):string; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadStockCode(FileName:string;index:string):string; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
    function  ReadCodetoList:boolean; //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;

    procedure ReSetFile(AFileName:String);
    function I2SDocType(i:integer):string;
    function I2SStrikeType(i:integer):string;
  end;

implementation
uses
  MainFrm;
var
  AMainFrm: TAMainFrm;

{$R *.dfm}

{ TRedeemInfoMgr }

constructor TRedeemInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TRedeemInfoMgr.CreateAID(var ID: String): Boolean;
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
     FRecLst[i].DETAILS[j].DOC_FILENAME :='NONE';
     FRecLst[i].DETAILS[j].START_DATE:=0;
     FRecLst[i].DETAILS[j].END_DATE:=0;
     FRecLst[i].DETAILS[j].REASON :='NONE';
     FRecLst[i].DETAILS[j].PRICE :=0;
   end;

   //ReadDocDat(ID);
    FNeedSaveUpload := True;
   Result := True;

end;


function TRedeemInfoMgr.DelAID(ID :String): Boolean;
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

procedure TRedeemInfoMgr.DelDocDat;
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

destructor TRedeemInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TRedeemInfoMgr.GetID(Index: Integer): String;
begin
   Result := FRecLst[Index].ID;
end;

function TRedeemInfoMgr.GetIDCount: Integer;
begin
   Result := High(FRecLst)+1;
end;

Function TRedeemInfoMgr.GetReasonText():String; //--DOC4.0.0—N003 huangcq090209 add
var
  AReasonLst:TStringList;
  AF:TIniFile;
  AIndex,i:integer;
begin
  Result:='';
  try
    AReasonLst:=TStringList.Create;
    AF:=TIniFile.Create(FFileName);
    // Modified by wjh 20110823  赎回卖回显示不正确
    AF.WriteString('ReasonList','0','NONE');//确保 约定原因Code的存在
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

Function TRedeemInfoMgr.GetContentWithIndex(IndexStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
var
  AF:TIniFile;
begin
  try
    Result := '';
    AF := TIniFile.Create(FFileName);
    Result := AF.ReadString('ReasonList',IndexStr,'NONE');
  finally
    if Assigned(AF) then AF.Free;
  end;
end;

Function TRedeemInfoMgr.GetIndexWithContent(ContentStr:String):String;//--DOC4.0.0—N003 huangcq090209 add
var
  AF:TIniFile;
  ValueLst:TStringList;
begin
  try
    Result := 'NONE';
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

function TRedeemInfoMgr.GetMemoText: String;
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

procedure TRedeemInfoMgr.Init;
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
   SetLength(FRecLst,_GetSecRedeemSaleDataCount(PChar(FFileName)));
   _GetRedeemSaleDataAll(FRecLst);

   SortIDLst_RedeemSale(FRecLst);
except
  On E:Exception Do
     ShowMessage(E.Message);
End;
Finally
  if Assigned(f) Then
     f.Free;
End;
end;

procedure TRedeemInfoMgr.Sort(Var aRecLst:Array of TREDEEMSALE_PERIOD_DETAIL);
var
  i,j:integer;
  Rec_tmp :TREDEEMSALE_PERIOD_DETAIL;
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

procedure TRedeemInfoMgr.ReadDocDat(const ID: String);
Var
  Str : String;
  StrLst:_CStrLst2;
  i : integer;
Begin

  SaveDocDat;

  FNowID := ID;
  With FARedeemSaleInfo Do
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
        With FARedeemSaleInfo Do
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

procedure TRedeemInfoMgr.ReadRedeemSaleDate(const ID: String);
var
  i,j:integer;
begin
  SetLength(FDateLst,0);
  For i:=0 to High(FRecLst) do
  Begin
    if(FRecLst[i].ID=ID)then
    Begin
      For j:=0 To high(FRecLst[i].DETAILS) do
      begin
        SetLength(FDateLst,High(FDateLst)+2);
        FDateLst[high(FDateLst)].DOC_FILENAME:=FRecLst[i].DETAILS[j].DOC_FILENAME;
        FDateLst[high(FDateLst)].START_DATE:=FRecLst[i].DETAILS[j].START_DATE;
        FDateLst[high(FDateLst)].END_DATE:=FRecLst[i].DETAILS[j].END_DATE;
        FDateLst[high(FDateLst)].PRICE:=FRecLst[i].DETAILS[j].PRICE;
        FDateLst[high(FDateLst)].REASON:=FRecLst[i].DETAILS[j].REASON;
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

procedure TRedeemInfoMgr.GetRedeemSaleDate(Const ID:String;var DateLst:Array of TREDEEMSALE_PERIOD_DETAIL);
var
  i:integer;
begin
  ReadRedeemSaleDate(ID);

  For i:=0 To high(FDateLst) do
  begin
    DateLst[i]:=FDateLst[i];
  end;
end;

procedure TRedeemInfoMgr.SaveRedeemSaleDate(Const ID:String;Const DateLst:Array of TREDEEMSALE_PERIOD_DETAIL);
var
  i,j:integer;
begin
try
  For i:=0 to High(FRecLst) do
  Begin
    if(FRecLst[i].ID=ID)then
    Begin
      For j:=0 To high(FRecLst[i].DETAILS) do
      begin
        FRecLst[i].DETAILS[j].DOC_FILENAME:=DateLst[j].DOC_FILENAME;
        FRecLst[i].DETAILS[j].START_DATE:=DateLst[j].START_DATE;
        FRecLst[i].DETAILS[j].END_DATE:=DateLst[j].END_DATE;
        FRecLst[i].DETAILS[j].PRICE:=DateLst[j].PRICE;
        //FRecLst[i].DETAILS[j].REASON:=DateLst[j].REASON; //--DOC4.0.0—N003 huangcq090209 del
        FRecLst[i].DETAILS[j].REASON:=GetIndexWithContent(DateLst[j].REASON); //--DOC4.0.0—N003 huangcq090209 add
      end;
      SaveRedeemSaleFile(ID,FRecLst[i].DETAILS);//在这里也实时的把这数据保存起来 --DOC4.0.0—N004 huangcq090317 add
      break;
    End;
  End;
  //SaveRedeemSaleFile(ID,DateLst);//在这里也实时的把这数据保存起来 --DOC4.0.0—N004 huangcq090317 add
  FNeedSaveUpload := True;
except

end;

end;

//--DOC4.0.0—N004 huangcq090317 add
Function TRedeemInfoMgr.SaveRedeemSaleFile(Const ID:String;Const DateLst:Array of TREDEEMSALE_PERIOD_DETAIL):Boolean;
var
  f:TIniFile;
  i:Integer;
  AStr:String;
begin
  Result:=False;
  try
    Try
      f:=TIniFile.Create(FFileName);
      f.EraseSection(ID);
      For i:=0 to high(DateLst) do
      begin
        AStr:=Format('%s,%s,%s,%s,%s',
                [FormatDateTime('yyyymmdd',DateLst[i].START_DATE),
                FormatDateTime('yyyymmdd',DateLst[i].END_DATE),
                FloatToStr(DateLst[i].PRICE),
                DateLst[i].Reason,
                DateLst[i].Doc_FileName]);
        f.WriteString(ID,IntToStr(i+1),AStr);
      end;
      Result:=True;
    finally
      f.Free;
    end;
  except
  end;
end;



procedure TRedeemInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TRedeemInfoMgr.SaveDocDat;
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
        With  FARedeemSaleInfo do
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


function TRedeemInfoMgr.UpdateAID(var ID: String; nowID:String): Boolean;
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

function TRedeemInfoMgr.GetRedeemSaleFileName: String;
var
  Strfilename:String;
begin
  Result :='';
try
  //Strfilename:=GetWinTempPath+Get_GUID8+'.dat';
  //if _SaveSecRedeemSaleFile(FRecLst,PChar(Strfilename)) then
    //result:=Strfilename;
  Result:=FFileName; 
except

end;

end;

procedure TRedeemInfoMgr.Setbesave;
begin
   FNeedSaveUpload := True;
end;

procedure TRedeemInfoMgr.SetARedeemSaleInfo(
  const Value: TARedeemSaleInfo);
begin
  FARedeemSaleInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

{ TACBDocFrm }

procedure TACBRedeemDateFrm.Init(Const FileName:String);
Var
  i : Integer;
begin
   FLockMemoChange := True;
   CreateDefauleItem;
   chkV.Caption:=FAppParam.ConvertString('显示公告列表');
   if Not Assigned(ARedeemInfoMgr) Then
      ARedeemInfoMgr := TRedeemInfoMgr.Create(FileName);

   BeSave;

   List_ID.Clear;
   For i:=0 to ARedeemInfoMgr.IDCount-1 do
       List_ID.Items.Add(ARedeemInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      ShowDocData;
   End;
   List_IDClick(nil);

   RefreshReasonDropItem(ARedeemInfoMgr.GetReasonText);

end;

procedure TACBRedeemDateFrm.RefreshReasonDropItem(ReasonStr:String); 
begin
  ListValue.BeginUpdate;
  Column_Reason.Items.Clear;
  Column_Reason.Items.Text:=ReasonStr;
  ListValue.EndUpdate;
end;


function TACBRedeemDateFrm.ReturnReasonTypeStr(
  pReasonType: ReasonType): String;
begin
  Result:='';
  case pReasonType of
    RsnTypeRedeem:Result:='赎回';
    RsnTypeSale:Result:='卖回';
  end;
end;

procedure TACBRedeemDateFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  //ARedeemInfoMgr.ReadDocDat(ID);
end;

procedure TACBRedeemDateFrm.SetInit(Parent: TWinControl;Const FileName,pIdLstFile:String);
var sFile,sLine:string;
    fini:TiniFile;
    i,iCount:integer;
begin
    FReasonTag:=RsnTypeRedeem; //
    Column_A5_doc.Visible:=FAppParam.IsTwSys;
    Column_A6_doc.Visible:=FAppParam.IsTwSys;

    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');
    Btn_RedeemReason.Caption:=FAppParam.ConvertString('>>赎回原因');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('开始日期');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('停止日期');
    ListValue.Columns[4].Caption := FAppParam.ConvertString('赎回价格');
    ListValue.Columns[5].Caption := FAppParam.ConvertString('赎回原因');

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
    FDocTypeList:=TStringList.Create;
    FStrikeTypeList:=TStringList.Create;
    //FDocLstFile:= adoclstfile;
    FIDLstFile := pIdLstFile;

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
  {
  if not ReadCodetoList then  //CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
     showmessage(FAppParam.ConvertString('转换股票代码没有加载成功，请重新启动'));//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
  }
  if not FileExists(FIDLstFile) then
     showmessage(FAppParam.ConvertString('转换股票代码没有加载成功，请重新启动'));

  Init(FileName);


end;

procedure TACBRedeemDateFrm.ShowLoadDocData;
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
     With  ARedeemInfoMgr.ARedeemSaleInfo Do
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

procedure TACBRedeemDateFrm.ShowDocData;
Var
  ID : String;
  AItem : TdxTreeListNode;
  i:integer;
  //DateLst:Array of TREDEEMSALE_PERIOD_DETAIL;
begin
try
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);

  ListValue.ClearNodes;

  SetLength(DateLst,0);
  SetLength(DateLst,16);
  ARedeemInfoMgr.GetRedeemSaleDate(ID,DateLst);

  For i:=0 to High(DateLst)do
  begin
    AItem :=  ListValue.Add;
    AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
    if(DateLst[i].START_DATE=66842)then
    begin
      AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_Reason').Index] := 'NONE';
      AItem.Strings[ListValue.ColumnByName('Column_Price').Index] := 'NONE';
    end
    else
    begin
      AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FormatDateTime('YYYY-MM-DD',DateLst[i].START_DATE);
      AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := FormatDateTime('YYYY-MM-DD',DateLst[i].END_DATE);
      AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := DateLst[i].DOC_FILENAME;
      //AItem.Strings[ListValue.ColumnByName('Column_Reason').Index] := DateLst[i].REASON;
      AItem.Strings[ListValue.ColumnByName('Column_Reason').Index] := ARedeemInfoMgr.GetContentWithIndex(DateLst[i].REASON); //--DOC4.0.0—N003 huangcq090209 add
      AItem.Strings[ListValue.ColumnByName('Column_Price').Index] := FloatToStr(DateLst[i].PRICE);
    end;
  end;

except

end;

End;

procedure TACBRedeemDateFrm.SaveRedeemSaleData(aindex:integer);
Var
  ID,Str : String;
  AItem : TdxTreeListNode;
  i:integer;
  DateLst:Array of TREDEEMSALE_PERIOD_DETAIL;
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
    if(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]='NONE') or
      (AItem.Strings[ListValue.ColumnByName('Column_A2').Index]='NONE') or
      (AItem.Strings[ListValue.ColumnByName('Column_Price').Index]='NONE') then
    begin
      DateLst[i].START_DATE := 0;
      DateLst[i].END_DATE := 0;
      DateLst[i].DOC_FILENAME :='NONE';
      DateLst[i].REASON :='NONE';
      DateLst[i].PRICE :=0;
    end
    else
    begin
      DateLst[i].START_DATE := strToDate(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
      DateLst[i].END_DATE := strToDate(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
      DateLst[i].DOC_FILENAME :=AItem.Strings[ListValue.ColumnByName('Column_A3').Index];
      DateLst[i].REASON :=AItem.Strings[ListValue.ColumnByName('Column_Reason').Index];
      DateLst[i].PRICE :=StrToFloat(AItem.Strings[ListValue.ColumnByName('Column_Price').Index]);
    end;

  end;
  DateSeparator:=FDateSeparator;

  Sort(DateLst);
  {For i:=0 to High(DateLst) do
  begin
    if(DateLst[i].START_DATE=66842)then
      DateLst[i].START_DATE := 0;
  end;}
  ARedeemInfoMgr.SaveRedeemSaleDate(ID,DateLst);

except

end;

End;

procedure TACBRedeemDateFrm.Sort(Var aRecLst:Array of TREDEEMSALE_PERIOD_DETAIL);
var
  i,j:integer;
  Rec_tmp :TREDEEMSALE_PERIOD_DETAIL;
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

function TACBRedeemDateFrm.SaveDocData :boolean;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TARedeemSaleInfo;
  Str : String;
begin

Try

   ADateInfo  := ARedeemInfoMgr.ARedeemSaleInfo;
   Result:=false;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];

     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
     if (str<>'NONE')then
        if Not IsDate(Str) Then
        begin
          AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := 'NONE';
          Raise Exception.Create(FAppParam.ConvertString('第'+IntTostr(i+1)+'行日期输入错误'));
        end;

     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
     if (str<>'NONE')then
        if Not IsDate(Str) Then
        begin
          AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := 'NONE';
          Raise Exception.Create(FAppParam.ConvertString('第'+IntTostr(i+1)+'行日期输入错误'));
        end;

     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_Price').Index]);
     if (str<>'NONE')then
        if Not IsInteger2(PChar(Str)) Then
        begin
          AItem.Strings[ListValue.ColumnByName('Column_Price').Index] := 'NONE';
          Raise Exception.Create(FAppParam.ConvertString('第'+IntTostr(i+1)+'行价格输入错误'));
        end;
   End;

    if FHaveChangeData=true then //--Doc3.2.0需求2 huangcq080926 add
    begin
      ARedeemInfoMgr.Setbesave;//FHaveChangeData<>true则没调用本句，也不会出现FNeedSaveUpload:=True
      SaveRedeemSaleData(nowindex); //--Doc3.2.0需求2 huangcq080926 add
    end;

    FHaveChangeData := False;
    Result:=true;
    //ARedeemInfoMgr.Setbesave; //--Doc3.2.0需求2 huangcq080926 del  被前移

except
  On E:Exception do
    ShowMessage(E.Message);
End;

end;

function TACBRedeemDateFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
  SaveDocData;

  Result := '';
  if Assigned(ARedeemInfoMgr) Then
     Result := ARedeemInfoMgr.GetMemoText;  

end;

procedure TACBRedeemDateFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBRedeemDateFrm.List_IDClick(Sender: TObject);
begin
   //LoadDocData;
   //ShowLoadDocData;
   if SaveDocData then
   begin
     //SaveRedeemSaleData(nowindex); //--Doc3.2.0需求2 huangcq080926 del
     ShowDocData;
     nowindex:=List_ID.ItemIndex;
     LoadDocTitle(nowindex);
   end
   else
     List_ID.ItemIndex:=nowindex;

end;

procedure TACBRedeemDateFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0);
end;

procedure TACBRedeemDateFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBRedeemDateFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBRedeemDateFrm.CreateDefauleItem;
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

procedure TACBRedeemDateFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBRedeemDateFrm.Btn_RefreshClick(Sender: TObject);
begin
   ShowDocData;
end;

procedure TACBRedeemDateFrm.Refresh(const FileName: String);
begin
   ARedeemInfoMgr.Reback(FileName);
   Init(FileName);
   ShowDocData;
end;

////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求1-leon-08/8/13;
//在每次新增完ID后，将当前焦点的index传给代表当前焦点index的nowindex参数，达到准确定位的目的；不会在新增后还是将值传给上次定位的ID中；
////////////////////////////////////////////////////////////////////////////
procedure TACBRedeemDateFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ARedeemInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      nowindex:=List_ID.ItemIndex;//add by leon 080813
      ShowDocData;
   End;
end;
//////////////////////////////////////////////////////////////////////////

procedure TACBRedeemDateFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin
Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ARedeemInfoMgr.DelAID(List_ID.Items[List_ID.ItemIndex]) Then
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
      nowindex := List_ID.ItemIndex;
   End;
Finally
End;



end;

procedure TACBRedeemDateFrm.Txt_IDChange(Sender: TObject);
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

function TACBRedeemDateFrm.NeedSave: Boolean;
begin
   Result := ARedeemInfoMgr.FNeedSaveUpload
end;

procedure TACBRedeemDateFrm.BeSave;
begin

  ARedeemInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBRedeemDateFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData :=  True;
end;


procedure TACBRedeemDateFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin
   if List_ID.ItemIndex<0 Then
      exit;

   if ARedeemInfoMgr.UpdateAID(ID,List_ID.Items[List_ID.ItemIndex]) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;
end;

procedure TACBRedeemDateFrm.ReSetFile(AFileName:String);
var
  i,j:Integer;
  ts:TStrings;
  vLine,ReasonInfo:String;
begin
  if not FileExists(AFileName) then
     exit;
  ReasonInfo := '';
  try
  try
    ts := TStringList.Create;
    ts.LoadFromFile(AFileName);
    for i := 0 to ts.Count - 1 do
    begin
      if SameText('[ReasonList]',ts[i]) then
      begin
        ReasonInfo := ts[i];
        for j := i + 1 to ts.Count - 1 do
        begin
          vLine := ts[j];
          if (Length(vLine)>0) and
             (vLine[1]='[') and
             (vLine[Length(vLine)]=']') then break;
          ReasonInfo := ReasonInfo+#13#10+vLine;
        end;
        break;
      end;
    end;
    ts.Clear;
    ts.Text := ReasonInfo;
    ts.SaveToFile(AFileName);
  except
    on e:Exception do
    begin
      ShowMessage(e.Message);
      e := nil;
    end;
  end;
  finally
    if Assigned(ts) then
      FreeAndNil(ts);
  end;
end;



function TACBRedeemDateFrm.GetFileName: String;
var
  i:Integer;
begin
try
  //SaveRedeemSaleData(List_ID.ItemIndex);
  with ARedeemInfoMgr do
  begin
    ReSetFile(FFileName);
    if nowindex <> -1 then
      for i := Low(FRecLst) to High(FRecLst) do
      begin
        Application.ProcessMessages;
        if not SameText(FRecLst[i].ID,List_ID.Items[nowindex]) then
          SaveRedeemSaleFile(FRecLst[i].ID,FRecLst[i].DETAILS);
      end;

  end;

  SaveRedeemSaleData(nowindex);
  Result:=ARedeemInfoMgr.GetRedeemSaleFileName;
except
  on e:Exception do
  begin
    showMessage(e.Message);
    e := nil;
  end;
end;

end;

function TACBRedeemDateFrm.FreeTheDocTitleLst():Boolean;
begin
  Result:=False;
  try
    if FDocLst<>nil then
    begin
      While FDocLst.Count>0 do
      Begin
        if (FDocLst.Items[0] <>nil) then
        begin
          FreeMem(FDocLst.Items[0]);
          FDocLst.Delete(0);
        end;
      End;
      FDocLst.Free;
      FDocLst:=nil;
      Result:=True;
    end;
  except
  end;
end;

function TACBRedeemDateFrm.LoadDocTitle(aindex:integer): Boolean;
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
    
    //FDocLst.Clear; //--huangcq090317 del
    //--huangcq090317 add--->
    FreeTheDocTitleLst();
    if not Assigned(FDocLst) then
      FDocLst:=TList.Create;
    //<--huangcq090317 add---

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

    ListValue_doc.BeginUpdate;
    ListValue_doc.ClearNodes;
    ListValue_doc.Refresh;
    For i:=0 To FDocLst.Count-1 Do
    Begin
      //CBRedeemSaleFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
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
    ListValue_doc.EndUpdate;
  except

  end;

end;
//CBRedeemSaleFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
//*************************************************************************
function TACBRedeemDateFrm.ReadDoclst(aID: String; var aDocLst:TList): Boolean;
var
  DocTitle :PDocTitle;
  DocLst:TStringList;
  i,j,index :integer;
  Str,Str2,aRtf,aDate,aTitle:String;
  FileName:string; //添加新变量
  ADateSep:char;  aDocType,aStrikeType:byte;
begin
   result :=false;
  try
    try
      DocLst := TStringList.Create;
       //CBRedeemSaleFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
      //----------------------------------加载个股公告列表
      if FAppParam.IsTwSys then
      begin
        FileName:=AMainFrm.ReadNewDoc('DOC_'+aID+'.TXT');
      end
      else
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
               DocTitle.ID:='';
               inc(j);
               GetTitle3(j,aID,Str,Str2,DocTitle); //
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
        //CBRedeemSaleFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-修改
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

    finally
      DocLst.Free;
    end;
  except
  end;
end;
//**************************************************************************
function TACBRedeemDateFrm.GetTitle(aindex:integer;aID,aStr: String; var aDocTitle: PDocTitle): Boolean;
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


procedure TACBRedeemDateFrm.ListValue_docDblClick(Sender: TObject);
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

   if not Assigned(AItem1) then exit;
   if not Assigned(AItemNew) then exit;

   for i:=0 to ListValue_doc.Count-1 Do
   Begin
       AItemOld := ListValue_doc.Items[i];
       if (AItemOld.Strings[ListValue_doc.ColumnByName('Column_Chk').Index]='true') then
       begin
         AItemOld.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'false';
         break;
       end;
   End;


  //listvalue_doc.IndexOf(AItemNew)=ListValue_doc.IndexOf(AItemOld)
  if Assigned(AItemOld) and (AItemNew.Index=AItemOld.Index) then  //原先选择与新选择是同一条，则取消选择
    AItem1.Strings[ListValue.ColumnByName('Column_A3').Index] :=''
  else begin
    AItemNew.Strings[ListValue_doc.ColumnByName('Column_Chk').Index] := 'true';
    AItem1.Strings[ListValue.ColumnByName('Column_A3').Index] :=AItemNew.Strings[ListValue_doc.ColumnByName('Column_A4_doc').Index];
    showmessage(AItem1.Strings[ListValue.ColumnByName('Column_A3').Index])
  end;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveRedeemSaleData(nowindex);
Finally
   ListValue_doc.EndUpdate;
   ListValue_doc.Repaint;
End;
end;

procedure TACBRedeemDateFrm.ListValueClick(Sender: TObject);
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

procedure TACBRedeemDateFrm.RefID;
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


procedure TACBRedeemDateFrm.Btn_RedeemReasonClick(Sender: TObject);
var
  AFileName:String;
  AShowResult:Boolean;
begin
  if not Assigned(ARedeemInfoMgr) then
    exit;
  try
    AFileName:=ARedeemInfoMgr.FFileName;
    AReasonEditFrm:=TAReasonEditFrm.Create(self);
    AShowResult:=AReasonEditFrm.ShowReasonFrm(FAppParam,FReasonTag,AFileName);
    if AShowResult then
    begin
      //原因内容有变动需上传
      ARedeemInfoMgr.FNeedSaveUpload := True;
      //更新下拉框的原因选择内容
      RefreshReasonDropItem(ARedeemInfoMgr.GetReasonText);
      List_IDClick(nil);
      //ShowDocData;
    end;
  finally
    AReasonEditFrm.Free;
  end;
end;

procedure TACBRedeemDateFrm.Column_ReasonButtonClick(Sender: TObject);
begin
  Btn_RedeemReason.Click;
end;

//CBRedeemSaleFrm2.0.0.0-Doc2.3.0.0-需求3-libing-2007/09/20-新增
//*****************************************************************
procedure TACBRedeemDateFrm.btnAddAlldocClick(Sender: TObject);
var
  DocTitle,DocTitle2 :PAllDocTitle; //完善公告可勾选功能20080328 modify by cody
  DocLst:TStringList;
  i,j,index:integer;
  Str:String;
  FileName,aID:string;
  DocTemp,aDocLst:TList;
  AItem : TdxTreeListNode;
  ARedeemInfoMgr:TRedeemInfoMgr;
  TempfileName:string;
begin
 // result :=false;
  try
    DocLst := TStringList.Create;
    aDocLst:=TList.Create;
  //----------------------------------加载个股公告列表
    aID:=List_ID.Items[List_ID.ItemIndex]; //获取显示列表代码
    if FAppParam.IsTwSys then
      FileName:=GetWinTempPath+('shenbao'+aID+'_DOCLST.dat')
    else
      FileName:=GetWinTempPath+(aID+'_DOCLST.dat');//add by leon 080617
      
    if FAppParam.IsTwSys then
    begin
      //FileName:=GetWinTempPath+'shenbao'+aID+'_DOCLST.dat';
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
      //FileName:=GetWinTempPath+aID+'_DOCLST.dat';  //modify by leon 080619
    end;
    DocLst.LoadFromFile(FileName);
 //-----------------------------------加载个股公告列表
    TempfileName:=GetWinTempPath+'cbRedeemSale.dat';
    ARedeemInfoMgr:=TRedeemInfoMgr.Create(TempfileName);
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

function TACBRedeemDateFrm.GetTitle2(aindex: integer; aID, aStr: String;
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


function TACBRedeemDateFrm.GetTitle3(aindex: integer; aID, aStr,aStr2: String;
  var aDocTitle: PDocTitle): Boolean;
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

function TACBRedeemDateFrm.CheckStkCode(var AID:String):Boolean;
{
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
}
Var
  f : TIniFile;
begin
  Result := False;
  f := TIniFile.Create(FIDLstFile);
  AID := f.ReadString(AID,'ID','');
  f.Free;
  if Length(AID)>0 then
    Result := True;
end;


/////////////////////////////////////////////////////////////////////////////////
//CBDatEdit-DOC3.0.0需求2-leon-08/8/18-add;
//将全部tr1db中txt的每个项目的id的TradeCode与StkCode的值放入链表中
/////////////////////////////////////////////////////////////////////////////////
function TACBRedeemDateFrm.ReadCodetoList:Boolean;
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
function TACBRedeemDateFrm.ReadTreadCode(FileName:string;index:string):string;
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
function TACBRedeemDateFrm.ReadStockCode(FileName:string;index:string):string;
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

function  TACBRedeemDateFrm.DownDBdata(Const pDwnMemo:Integer):_CstrLst;
Var
  FileLst : _CstrLst;
  FilePath : String;
begin
   Case pDwnMemo of
    0: begin //cn
          FilePath := GetWinTempPath + 'CNDB_DATA\';
          MkDir_Directory(FilePath);
          AMainFrm.ReadNewDoc2('guapai.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('passaway.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('hushi.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('shenshi.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('nifaxing.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('pass.txt','CNDB_DATA');
          AMainFrm.ReadNewDoc2('stopissue.txt','CNDB_DATA');
       end;
    1: begin //tw
          FilePath := GetWinTempPath + 'TWDB_DATA\';
          MkDir_Directory(FilePath);
          AMainFrm.ReadNewDoc2('guapai.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('passaway.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('shanggui.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('shangshi.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('nifaxing.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('pass.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('song.txt','TWDB_DATA');
          AMainFrm.ReadNewDoc2('stopissue.txt','TWDB_DATA');
       end;
   end;
   FolderAllFiles(FilePath,'.TXT',FileLst);
   result:=FileLst;
end;




procedure TACBRedeemDateFrm.Column_ReasonChange(Sender: TObject);
begin
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
end;

procedure TACBRedeemDateFrm.chkVClick(Sender: TObject);
begin
  ListValue_doc.Visible:=chkV.Checked;
end;

function  TACBRedeemDateFrm.DownDBdata2():boolean;
Var
  FilePath : String;
begin
    FilePath := GetWinTempPath ;
    //AMainFrm.ReadNewDoc('shenbaoset.dat');
    result:=True;
end;

function TACBRedeemDateFrm.I2SDocType(i: integer): string;
begin
  result:='NONE';
  //showmessage('DocType:'+IntToStr(i)+#13#10+FDocTypeList.text);
  if (i-1>=0) and (i-1<FDocTypeList.Count) then
    Result:=FDocTypeList[i-1];
end;

function TACBRedeemDateFrm.I2SStrikeType(i: integer): string;
begin
  result:='NONE';
  //showmessage('StrikeType:'+IntToStr(i)+#13#10+FStrikeTypeList.text);
  if (i-1>=0) and (i-1<FStrikeTypeList.Count) then
    Result:=FStrikeTypeList[i-1];
end;

end.
