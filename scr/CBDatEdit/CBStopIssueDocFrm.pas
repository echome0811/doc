{*****************************************************************************
 创建标示：CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
 功能标示：公告加载速度过慢，调整为直接读取个股公告列表，默认加载一周内公告，
           可选择加载全部公告，公告按日期降序显示在界面。
 //修改勾选不能超越七日内问题20080125
*****************************************************************************}

unit CBStopIssueDocFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr, dxTLClms;

type

  TACBStopDocInfo=Record
     DocFileName : String;
     DocTitle : String;
     DocDate  : TDate;
  End;

  TCBDoc = Packed Record
    ACaption  : ShortString;
    FileName : ShortString;
    ADate     : TDate;
  End;

  TCBStopDocInfoMgr=Class
  private
    FFileName : String;
    FDocListFileName : String;
    FIDLstFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FNowIDDocLst : Array of TCBDoc;
    FSevenIDDocLst : Array of TCBDoc;  //添加保存七天内公告信息记录
    FFileMemo:TStringList;
    FACBStopDocInfo: TACBStopDocInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBStopDocInfo(const Value: TACBStopDocInfo);
    function GetStkID(BID:String):String;
    Procedure SetAIDDocLst(Const ID:String ; Amode:boolean);    //modify by leon 080626
//    Procedure SetAIDDocLst2(Const ID:String);//修改勾选不能超越七日内问题20080125   delete by leon 080626
  public
    Constructor Create(Const FileName:String;
                       Const DocListFile,IDLstFileName:String);
    Destructor Destroy();Override;
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    procedure ReadDocDat(Const ID:String ; Amode:boolean);   //modify by leon 080626
  //  procedure ReadDocDat2(Const ID:String);//修改勾选不能超越七日内问题20080125  delete by leon 080626
    procedure SaveDocDat();
    Function GetMemoText():String;
    procedure Reback(Const FileName,DocListFileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBStopDocInfo : TACBStopDocInfo read FACBStopDocInfo write SetACBStopDocInfo;
  End;

  TACBStopIssueDocFrm = class(TFrame)
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
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A2: TdxTreeListColumn;
    Panel_NowID: TPanel;
    Bevel5: TBevel;
    Panel_Doc: TPanel;
    Column_Chk: TdxTreeListCheckColumn;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    btnAddAll: TSpeedButton;
    procedure Cbo_SectionChange(Sender: TObject);
    procedure Txt_MemoChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);
    procedure Txt_InfoChange(Sender: TObject);
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
    procedure ListValueDblClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
  private
    { Private declarations }
    ACBStopDocInfoMgr : TCBStopDocInfoMgr;
    FLockMemoChange : Boolean;
    Procedure ResetNum();
    Procedure DeleteAData();
    Procedure InsertAData();
    Procedure AddAData();
    Procedure MoveUp();
    Procedure MoveDwn();
    procedure Init(Const FileName,DocListFileName,IDLstFileName:String);

  public
    { Public declarations }
    Procedure SaveDocData();
    Procedure LoadDocData();
    Procedure ShowLoadDocData();
    Procedure SetInit(Parent:TWinControl;Const FileName,
                     DocListFileName,IDLstFileName:String);
    Function GetMemoText():String;
    Procedure Refresh(Const FileName,DocListFileName,IDLstFileName:String);
    Function NeedSave():Boolean;
    Procedure BeSave();
    procedure RefID();
  end;


implementation
uses
  MainFrm;
var
  AMainFrm: TAMainFrm;
{$R *.dfm}

{ TACBDocFrm }

procedure TACBStopIssueDocFrm.Init(Const FileName,DocListFileName,IDLstFileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;


   ListValue.ClearNodes;

   if Not Assigned(ACBStopDocInfoMgr) Then
     ACBStopDocInfoMgr := TCBStopDocInfoMgr.Create(FileName,DocListFileName,IDLstFileName);

   BeSave;

   Panel_Doc.Caption := '';

   List_ID.Clear;
   For i:=0 to ACBStopDocInfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBStopDocInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;


end;

procedure TACBStopIssueDocFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBStopDocInfoMgr.ReadDocDat(ID,true);
end;

procedure TACBStopIssueDocFrm.SetInit(Parent: TWinControl;
Const FileName,DocListFileName,IDLstFileName:String);
begin

    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    btnAddAll.Caption:=FAppParam.ConvertString('加载全部公告');//CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改

    Panel_Memo.Caption := FAppParam.ConvertString('请输入Key值');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('日期');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('公告');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName,DocListFileName,IDLstFileName);
end;

procedure TACBStopIssueDocFrm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin
    FLockMemoChange := True;
    ListValue.BeginUpdate;
Try

   ListValue.ClearNodes;

   Panel_Doc.Caption := FAppParam.ConvertString('设定停发公告为 "')+
                         ACBStopDocInfoMgr.ACBStopDocInfo.DocTitle+'"';

   For i:=0 to High(ACBStopDocInfoMgr.FSevenIDDocLst) do   //修改勾选不能超越七日内问题20080125
   Begin
     AItem :=  ListValue.Add;
     With  ACBStopDocInfoMgr.FNowIDDocLst[i] Do   //FSevenIDDocLst   //修改勾选不能超越七日内问题20080125
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1); //序号
       AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FormatDateTime('yyyy-mm-dd',ADate); //日期
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := ACaption;    //公告

       if ACBStopDocInfoMgr.ACBStopDocInfo.DocFileName=FileName Then
       Begin
          AItem.Focused  := True;
          AItem.Selected := True;
          AItem.Strings[ListValue.ColumnByName('Column_Chk').Index] := 'true';  //勾选
       End;
     End;
   End;
Finally
   FLockMemoChange := false;
   ListValue.EndUpdate;
End;
end;

procedure TACBStopIssueDocFrm.SaveDocData;
Var
  i ,j: Integer;
  AItem : TdxTreeListNode;
  AStopDocInfo  : TACBStopDocInfo;
begin

   ListValue.BeginUpdate;
Try
    //ACBStopDocInfoMgr:=TCBStopDocInfoMgr.Create();
   AStopDocInfo  := ACBStopDocInfoMgr.ACBStopDocInfo;

   AStopDocInfo.DocFileName := '';
   AStopDocInfo.DocTitle := '';
   AStopDocInfo.DocDate := 0;

   for i:=0 to ListValue.Count-1 Do
   Begin
       AItem := ListValue.Items[i];
       AItem.Strings[ListValue.ColumnByName('Column_Chk').Index] := 'false';
   End;

   AItem := ListValue.FocusedNode;
   if Assigned(AItem) Then
   Begin
       AItem.Strings[ListValue.ColumnByName('Column_Chk').Index] := 'true';
       With ACBStopDocInfoMgr.FNowIDDocLst[AItem.Index] Do
       Begin
          AStopDocInfo.DocFileName := FileName;
          AStopDocInfo.DocTitle := ACaption;
          AStopDocInfo.DocDate := ADate;
       End;
       ACBStopDocInfoMgr.ACBStopDocInfo := AStopDocInfo;
   End;

  // ACBStopDocInfoMgr.ACBStopDocInfo := AStopDocInfo;
   Panel_Doc.Caption := FAppParam.ConvertString('设定停发公告为 "')+
                         ACBStopDocInfoMgr.ACBStopDocInfo.DocTitle+'"';

Finally
   ListValue.EndUpdate;
   ListValue.Repaint;
End;

end;

function TACBStopIssueDocFrm.GetMemoText: String;
begin

  Result := '';
  if Assigned(ACBStopDocInfoMgr) Then
     Result := ACBStopDocInfoMgr.GetMemoText;  
end;

{ TCBStopDocInfoMgr }

constructor TCBStopDocInfoMgr.Create(Const FileName:String;
                       Const DocListFile,IDLstFileName:String);
begin

  FFileName := FileName;
//  FDocListFileName := DocListFile;     delete by leon 080626
  FIDLstFileName := IDLstFileName;

  FFileMemo := TStringList.Create;
  Init;

end;

function TCBStopDocInfoMgr.CreateAID(var ID: String): Boolean;
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

   ReadDocDat(ID,true);

   Result := True;
end;


function TCBStopDocInfoMgr.DelAID(): Boolean;
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

destructor TCBStopDocInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBStopDocInfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBStopDocInfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBStopDocInfoMgr.GetMemoText: String;
begin
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

function TCBStopDocInfoMgr.GetStkID(BID: String): String;
Var
  f : TIniFile;
begin
  f := TIniFile.Create(FIDLstFileName);
  Result := f.ReadString(BID,'ID','');
  f.Free;
end;

procedure TCBStopDocInfoMgr.Init;
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
           j := High(FIDLst)+1;
           SetLength(FIDLst,j+1);
           FIDLst[j] := Str;
       End;
   End;
   SortIDLst(FIDLst);
   ACBStopDocInfo:=FACBStopDocInfo;

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



procedure TCBStopDocInfoMgr.ReadDocDat(const ID: String; Amode:boolean);
Var
  f : TIniFile;
  i : integer;
Begin
  SaveDocDat;
  f := TIniFile.Create(FFileName);
  FNowID := ID;
  SetLength(FNowIDDocLst,0);
  Try
    Try
      FACBStopDocInfo.DocFileName := f.ReadString(ID,'1','');

      FACBStopDocInfo.DocTitle := '';
      FACBStopDocInfo.DocDate := 0;

      SetAIDDocLst(ID,Amode);

      For i:=0 to High(FNowIDDocLst) Do
      Begin

         if FNowIDDocLst[i].FileName=FACBStopDocInfo.DocFileName  Then  //是否为勾选公告信息
         Begin
           FACBStopDocInfo.DocTitle := FNowIDDocLst[i].ACaption;
           FACBStopDocInfo.DocDate  := FNowIDDocLst[i].ADate;
           Break;
         End;
      End;
    Except
    End;
  Finally
     f.Free;
  End;
end;
//修改勾选不能超越七日内问题20080125
//*****************************************************************
{procedure TCBStopDocInfoMgr.ReadDocDat2(const ID: String);   //修改勾选不能超越七日内问题20080125
Var
  f : TIniFile;
  i : integer;
Begin
  SaveDocDat;
  f := TIniFile.Create(FFileName);
  FNowID := ID;
  SetLength(FNowIDDocLst,0);
  Try
    Try
      FACBStopDocInfo.DocFileName := f.ReadString(ID,'1','');

      FACBStopDocInfo.DocTitle := '';
      FACBStopDocInfo.DocDate := 0;

      SetAIDDocLst2(ID);

      For i:=0 to High(FNowIDDocLst) Do
      Begin

         if FNowIDDocLst[i].FileName=FACBStopDocInfo.DocFileName  Then  //是否为勾选公告信息
         Begin
           FACBStopDocInfo.DocTitle := FNowIDDocLst[i].ACaption;
           FACBStopDocInfo.DocDate  := FNowIDDocLst[i].ADate;
           Break;
         End;
      End;
    Except
    End;
  Finally
     f.Free;
  End;

end; }
//********************************************************
procedure TCBStopDocInfoMgr.Reback(const FileName,DocListFileName: String);
begin
  FFileName := FileName;
 // FDocListFileName := DocListFileName;   delete by leon 080626
  FNowID := '';
  Init;
end;

procedure TCBStopDocInfoMgr.SaveDocDat;
Var
  f : TIniFile;
Begin

  if Length(FNowID)=0 Then
    Exit;
  if Not FNeedSave Then
     Exit;

  f := TIniFile.Create(FFileName);

  Try
  Try
    f.EraseSection(FNowID);
    f.WriteString(FNowID,'1',FACBStopDocInfo.DocFileName);
  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;
end;


procedure TACBStopIssueDocFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBStopIssueDocFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBStopIssueDocFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TCBStopDocInfoMgr.SetACBStopDocInfo(
  const Value: TACBStopDocInfo);
begin
  FACBStopDocInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBStopIssueDocFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBStopIssueDocFrm.DeleteAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;
    if Not Assigned(AItem) Then
       Exit;

   AItem.Free;

   ResetNum;

end;

procedure TACBStopIssueDocFrm.InsertAData;
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

procedure TACBStopIssueDocFrm.MoveDwn;
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

procedure TACBStopIssueDocFrm.MoveUp;
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

procedure TACBStopIssueDocFrm.ResetNum;
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

procedure TACBStopIssueDocFrm.Refresh(const FileName,DocListFileName,IDLstFileName: String);
begin
   ACBStopDocInfoMgr.Reback(FileName,DocListFileName);
   Init(FileName,DocListFileName,IDLstFileName);
end;

procedure TACBStopIssueDocFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBStopIssueDocFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBStopIssueDocFrm.Btn_DeleteClick(Sender: TObject);
begin
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  Begin
    DeleteAData;
    SaveDocData;
  End;
end;

procedure TACBStopIssueDocFrm.Btn_InsertClick(Sender: TObject);
begin
   InsertAData;
end;

procedure TACBStopIssueDocFrm.Btn_MoveUpClick(Sender: TObject);
begin
 MoveUp;
 SaveDocData;
end;

procedure TACBStopIssueDocFrm.Btn_MoveDwnClick(Sender: TObject);
begin
  MoveDwn;
  SaveDocData;
end;

procedure TACBStopIssueDocFrm.Txt_LowResetChange(Sender: TObject);
begin
  if Not FLockMemoChange Then
    SaveDocData;
end;

procedure TACBStopIssueDocFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBStopDocInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBStopIssueDocFrm.AddAData;
begin
   ListValue.Add;
   ResetNum;
end;

procedure TACBStopIssueDocFrm.Btn_AddClick(Sender: TObject);
begin
   AddAData;
end;

procedure TACBStopIssueDocFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin
Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBStopDocInfoMgr.DelAID() Then
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

procedure TACBStopIssueDocFrm.Txt_IDChange(Sender: TObject);
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

function TACBStopIssueDocFrm.NeedSave: Boolean;
begin
   Result := ACBStopDocInfoMgr.FNeedSaveUpload ;
end;

procedure TACBStopIssueDocFrm.BeSave;
begin
   ACBStopDocInfoMgr.FNeedSaveUpload := False;
end;
//CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
//******************************************************************
procedure TCBStopDocInfoMgr.SetAIDDocLst(Const ID: String;Amode : boolean);
  Procedure SortDocLst(Var Buffer:Array of TCBDoc);    //0 递增 1 递减
  var
    //排序用
    lLoop1,lHold,lHValue : Longint;
    lTemp : TCBDoc;
    i,Count :Integer;
  Begin
    if High(Buffer)<0 then exit;
    i := High(Buffer)+1;
    Count   := i;
    lHValue := Count-1;
    repeat
        lHValue := 3 * lHValue + 1;
    Until lHValue > (i-1);

    repeat
          lHValue := Round2(lHValue / 3);
          For lLoop1 := lHValue  To (i-1) do
          Begin

              lTemp  := Buffer[lLoop1];
              lHold  := lLoop1;
              while Buffer[lHold - lHValue].ADate  < lTemp.ADate do
              Begin
                   Buffer[lHold] := Buffer[lHold - lHValue];
                   lHold := lHold - lHValue;
                   If lHold < lHValue Then break;
              End;
              Buffer[lHold] := lTemp;
          End;
    Until lHValue = 0;
  End;

Var
  f : TStringList;
  DocLst : _CstrLst;
  GetDateLst : _CstrLst;  //获取公告日期变量
  Str,FileName : ShortString;
  DocFileName,s : String;
  i,t1,t2,j1,j2 : Integer;
  Index : Integer;
  StkID : String;
Begin
  SetLength(DocLst,0);
  //SetLength(FNowIDDocLst,0);  //修改勾选不能超越七日内问题20080125-delete
if Amode then     //add by leon 080626
 begin
  SetLength(FSevenIDDocLst,0); //修改勾选不能超越七日内问题20080125-add
  //CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
//=============================================   //读取个股列表
  StkID := GetStkID(ID);
  FileName:=AMainFrm.ReadNewDoc(StkID+'_DOCLST.dat');
 end
//---------------------------------------------------- //add by leon 080626
else
  begin
      SetLength(FNowIDDocLst,0);
      StkID := GetStkID(ID);
      FileName:=GetWinTempPath+StkID+'_DOCLST.dat';
  end;
//----------------------------------------------------
 // FileName:=FAppParam.Tr1DBPath+'CBData\Document\StockDocIdxLst\'+StkID+'_DOCLST.dat';  delete by leon 080617
//=============================================
  //FileName    := FDocListFileName;      //获取doclst.dat
  if Not FileExists(FileName) Then Exit;
  try
    //StkID := GetStkID(ID);

    f := TStringList.Create;
    f.LoadFromFile(FileName);
    SetLength(FNowIDDocLst,0);
    index := Pos('['+StkID+']',f.Text);
    if index>0 Then
    Begin
      index := index+Length('['+StkID+']');
      f.Text:=Copy(f.text,index+1,Length(f.text)-index);
    End Else
      f.Clear;
  //CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
//=============================================================添加读取七日内公告逻辑
    for i:=1 to f.Count-2 do       // 除去读取第一行代码，直接读取公告列表
    Begin
      Str := f.Strings[i];
       GetDateLst:=DoStrArray(str,',');
       s:=GetDateLst[1];
       GetDateLst:=DoStrArray(s,'/');
       //修改勾选不能超越七日内问题20080125-add
       //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
        if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
          if Pos(',',Str)>0 Then
          Begin
              t1 := Pos('=',Str);
              t2 := Length(Str);
              Str := Copy(Str,t1+1,t2-t1);
              DocLst := DoStrArray(Str,',');
              j1 := High(FNowIDDocLst)+1;
              SetLength(FNowIDDocLst,j1+1);

              DocFileName := DocLst[0];
              ReplaceSubString('.txt','.rtf',DocFileName);

              FNowIDDocLst[j1].ACaption  := DocLst[1];
              FNowIDDocLst[j1].FileName  := DocFileName;
              FNowIDDocLst[j1].ADate := 0;
              DocLst := DoStrArray(DocLst[1],'/');
              if High(DocLst)>=1 Then
              Begin
                 FNowIDDocLst[j1].ACaption  := DocLst[0];
                 Try
                   FNowIDDocLst[j1].ADate := StrToDate2(DocLst[1]);
                 Except
                 End;
              End;
          End;
       //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
      // if (now-StrToDate(GetDateLst[1]))<=7 then
      if ((now-StrToDate(GetDateLst[1]))<=7) and Amode then//modify by leon 080626
       begin
        if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
          if Pos(',',Str)>0 Then
          Begin
              t1 := Pos('=',Str);
              t2 := Length(Str);
              Str := Copy(Str,t1+1,t2-t1);
              DocLst := DoStrArray(Str,',');
              j2 := High(FSevenIDDocLst)+1;
              SetLength(FSevenIDDocLst,j2+1);

              DocFileName := DocLst[0];
              ReplaceSubString('.txt','.rtf',DocFileName);

              FSevenIDDocLst[j2].ACaption  := DocLst[1];
              FSevenIDDocLst[j2].FileName  := DocFileName;
              FSevenIDDocLst[j2].ADate := 0;
              DocLst := DoStrArray(DocLst[1],'/');
              if High(DocLst)>=1 Then
              Begin
                 FSevenIDDocLst[j2].ACaption  := DocLst[0];
                 Try
                   FSevenIDDocLst[j2].ADate := StrToDate2(DocLst[1]);
                 Except
                 End;
              End;
          End;
        end;
    End;
//==============================================================

 {   for i:=0 to f.Count-1 do
    Begin
      Str := f.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if Pos(',',Str)>0 Then
      Begin
          t1 := Pos('=',Str);
          t2 := Length(Str);
          Str := Copy(Str,t1+1,t2-t1);
          DocLst := DoStrArray(Str,',');
          j := High(FNowIDDocLst)+1;
          SetLength(FNowIDDocLst,j+1);

          DocFileName := DocLst[0];
          ReplaceSubString('.txt','.rtf',DocFileName);

          FNowIDDocLst[j].ACaption  := DocLst[1];
          FNowIDDocLst[j].FileName  := DocFileName;
          FNowIDDocLst[j].ADate := 0;
          DocLst := DoStrArray(DocLst[1],'/');
          if High(DocLst)>=1 Then
          Begin
             FNowIDDocLst[j].ACaption  := DocLst[0];
             Try
               FNowIDDocLst[j].ADate := StrToDate2(DocLst[1]);
             Except
             End;
          End;
      End;

    End; }
    f.Free;
    //SortDocLst(FNowIDDocLst);
  Except
  End;
  SortDocLst(FNowIDDocLst);
  SortDocLst(FSevenIDDocLst);
End;
//******************************************************************************

procedure TACBStopIssueDocFrm.ListValueDblClick(Sender: TObject); ////修改勾选不能超越七日内问题20080125-add
begin
   WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
   SaveDocData;
end;

{procedure TCBStopDocInfoMgr.SetAIDDocLst2(const ID: String);
 Procedure SortDocLst(Var Buffer:Array of TCBDoc);    //0 递增 1 递减
  var
    //排序用
    lLoop1,lHold,lHValue : Longint;
    lTemp : TCBDoc;
    i,Count :Integer;
  Begin

    if High(Buffer)<0 then exit;

    i := High(Buffer)+1;
    Count   := i;
    lHValue := Count-1;
    repeat
        lHValue := 3 * lHValue + 1;
    Until lHValue > (i-1);

    repeat
          lHValue := Round2(lHValue / 3);
          For lLoop1 := lHValue  To (i-1) do
          Begin

              lTemp  := Buffer[lLoop1];
              lHold  := lLoop1;
              while Buffer[lHold - lHValue].ADate  < lTemp.ADate do
              Begin
                   Buffer[lHold] := Buffer[lHold - lHValue];
                   lHold := lHold - lHValue;
                   If lHold < lHValue Then break;
              End;
              Buffer[lHold] := lTemp;
          End;
    Until lHValue = 0;
  End;

Var
  f : TStringList;
  DocLst : _CstrLst;

  Str,FileName : ShortString;
  DocFileName : String;
  i,t1,t2,j : Integer;
  Index : Integer;
  StkID : String;
Begin
  SetLength(DocLst,0);
  SetLength(FNowIDDocLst,0);

  FileName    := FDocListFileName;
  if Not FileExists(FileName) Then Exit;

  try
    StkID := GetStkID(ID);

    f := TStringList.Create;
    f.LoadFromFile(FileName);
    SetLength(FNowIDDocLst,0);

    index := Pos('['+StkID+']',f.Text);
    if index>0 Then
    Begin
      index := index+Length('['+StkID+']');
      f.Text:=Copy(f.text,index+1,Length(f.text)-index);
    End Else
      f.Clear;
    for i:=0 to f.Count-1 do
    Begin
      Str := f.Strings[i];
      if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
          Break;
      if Pos(',',Str)>0 Then
      Begin
          t1 := Pos('=',Str);
          t2 := Length(Str);
          Str := Copy(Str,t1+1,t2-t1);
          DocLst := DoStrArray(Str,',');
          j := High(FNowIDDocLst)+1;
          SetLength(FNowIDDocLst,j+1);

          DocFileName := DocLst[0];
          ReplaceSubString('.txt','.rtf',DocFileName);

          FNowIDDocLst[j].ACaption  := DocLst[1];
          FNowIDDocLst[j].FileName  := DocFileName;
          FNowIDDocLst[j].ADate := 0;
          DocLst := DoStrArray(DocLst[1],'/');
          if High(DocLst)>=1 Then
          Begin
             FNowIDDocLst[j].ACaption  := DocLst[0];
             Try
               FNowIDDocLst[j].ADate := StrToDate2(DocLst[1]);
             Except
             End;
          End;
      End;
    End;
    f.Free;
    SortDocLst(FNowIDDocLst);
  Except
  End;
end;  }

function TCBStopDocInfoMgr.UpdateAID(var ID: String): Boolean;
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

procedure TACBStopIssueDocFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin
   if List_ID.ItemIndex<0 Then
      exit;

   if ACBStopDocInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
      LoadDocData;
      ShowLoadDocData;
   End;
end;

procedure TACBStopIssueDocFrm.RefID;
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
//CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
procedure TACBStopIssueDocFrm.btnAddAllClick(Sender: TObject);  //加载全部公告
  Procedure SortDocLst(Var Buffer:Array of TCBDoc); //0 递增 1 递减
  var
    //排序用
    lLoop1,lHold,lHValue : Longint;
    lTemp : TCBDoc;
    i,Count :Integer;
  Begin
    if High(Buffer)<0 then exit;

    i := High(Buffer)+1;
    Count   := i;
    lHValue := Count-1;
    repeat
        lHValue := 3 * lHValue + 1;
    Until lHValue > (i-1);

    repeat
          lHValue := Round2(lHValue / 3);
          For lLoop1 := lHValue  To (i-1) do
          Begin

              lTemp  := Buffer[lLoop1];
              lHold  := lLoop1;
              while Buffer[lHold - lHValue].ADate  < lTemp.ADate do
              Begin
                   Buffer[lHold] := Buffer[lHold - lHValue];
                   lHold := lHold - lHValue;
                   If lHold < lHValue Then break;
              End;
              Buffer[lHold] := lTemp;
          End;
    Until lHValue = 0;
  End;
var
  f : TStringList;
  DocLst : _CstrLst;
  Str,FileName,DocListFile,IDLstFileName: ShortString;
  DocFileName : String;
  i,t1,t2,j,IDIndex : Integer;
  Index : Integer;
  StkID : String;
//-------------------- 添加需要的变量
  ACBStopDocInfoMgr:TCBStopDocInfoMgr;
  ID:string;
  number:integer;
  AItem:TdxTreeListNode;
  fACBStopIssueDocFrm:TACBStopIssueDocFrm;
  AStopDocInfo  : TACBStopDocInfo;
begin
//创建TCBStopDocInfoMgr类
    FileName:=GetWinTempPath+'stopissuedocidx.dat';
    //DocListFile:= '';//GetWinTempPath+'doclst.dat';  delete by leon 080626
    IDLstFileName:=GetWinTempPath+'marketidlst.dat';
    ACBStopDocInfoMgr:=TCBStopDocInfoMgr.Create(FileName,DocListFile,IDLstFileName);
    SetLength(DocLst,0);
    SetLength(ACBStopDocInfoMgr.FNowIDDocLst,0);
    ID:=List_ID.Items[List_ID.ItemIndex];
    ACBStopDocInfoMgr.ReadDocDat(ID,false);
   // ACBStopDocInfoMgr.ReadDocDat2(ID);   ////修改勾选不能超越七日内问题20080125-modify
  //modify by leon 080626
    AStopDocInfo  := ACBStopDocInfoMgr.ACBStopDocInfo;

    StkID := ACBStopDocInfoMgr.GetStkID(ID);
   //FileName:=FAppParam.Tr1DBPath+'CBData\Document\StockDocIdxLst\'+StkID+'_DOCLST.dat';
    FileName:=GetWinTempPath+StkID+'_DOCLST.dat';//add by leon 080617
    if Not FileExists(FileName) Then Exit;

    try
      f := TStringList.Create;
      f.LoadFromFile(FileName);
      SetLength(ACBStopDocInfoMgr.FNowIDDocLst,0);
      index := Pos('['+StkID+']',f.Text);
      if index>0 Then
      Begin
        index := index+Length('['+StkID+']');
        f.Text:=Copy(f.text,index+1,Length(f.text)-index);
      End Else
        f.Clear;
      for i:=0 to f.Count-1 do
      Begin
        Str := f.Strings[i];
        if (Pos(',',Str)=0) and (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
            Break;
        if Pos(',',Str)>0 Then
        Begin
            t1 := Pos('=',Str);
            t2 := Length(Str);
            Str := Copy(Str,t1+1,t2-t1);
            DocLst := DoStrArray(Str,',');
            j:=High(ACBStopDocInfoMgr.FNowIDDocLst)+1;
            SetLength(ACBStopDocInfoMgr.FNowIDDocLst,j+1);

            DocFileName := DocLst[0];
            ReplaceSubString('.txt','.rtf',DocFileName);
            ACBStopDocInfoMgr.FNowIDDocLst[j].ACaption:=DocLst[1];
            ACBStopDocInfoMgr.FNowIDDocLst[j].FileName:=DocFileName;

            DocLst := DoStrArray(DocLst[1],'/');
            if High(DocLst)>=1 Then
            Begin
              ACBStopDocInfoMgr.FNowIDDocLst[j].ACaption:= DocLst[0];
               Try
                ACBStopDocInfoMgr.FNowIDDocLst[j].ADate:=StrToDate2(DocLst[1]);
               Except
               End;
            End;
        End;
      End;

      SortDocLst(ACBStopDocInfoMgr.FNowIDDocLst);
//CBStopIssueDocFrm2.0.0.0-Doc2.3.0.0-需求7-libing-2007/09/20-修改
//----界面全部公告显示---------
     fACBStopIssueDocFrm:=TACBStopIssueDocFrm.Create(nil);
     fACBStopIssueDocFrm.FLockMemoChange:=true;
     ListValue.BeginUpdate;
     try
        ListValue.ClearNodes;
        Panel_Doc.Caption:=FAppParam.ConvertString('设定停发公告为"')+ACBStopDocInfoMgr.ACBStopDocInfo.DocTitle+'"' ;
        for number:=0 to high(ACBStopDocInfoMgr.FNowIDDocLst)do
        begin
          AItem:=ListValue.Add;
          with ACBStopDocInfoMgr.FNowIDDocLst[number] do
          begin
            AItem.Strings[ListValue.ColumnByName('Column_Num').Index]:=IntToStr(number+1);
            AItem.Strings[ListValue.ColumnByName('Column_A1').Index]:=FormatDateTime('yyyy-mm-dd',ADate);
            AItem.Strings[ListValue.ColumnByName('Column_A2').Index]:=ACaption;
            if ACBStopDocInfoMgr.FNowIDDocLst[number].FileName =AStopDocInfo.DocFileName then   //   ACBStopDocInfoMgr.FACBStopDocInfo.DocFileName
            begin
              AItem.Focused:=true;
              AItem.Selected:=true;
              AItem.Strings[ListValue.ColumnByName('Column_Chk').Index]:='true';    //20080107
            end;
            ACBStopDocInfoMgr.ACBStopDocInfo := AStopDocInfo;
          end;
        end;
        ACBStopDocInfoMgr.SaveDocDat;
        SaveDocData;
     finally
        fACBStopIssueDocFrm.FLockMemoChange:=false;
        ListValue.EndUpdate;
     end;
//----界面全部公告显示---------
      f.Free;
    Except
    End;
end;
//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
end.
