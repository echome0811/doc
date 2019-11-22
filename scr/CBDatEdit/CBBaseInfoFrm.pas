unit CBBaseInfoFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr;

type

  TABaseInfo=Record
    Value : Array[0..1] of String;
  End;

  TACBBaseInfo=Record
     HolderLst : Array of TABaseInfo;
  End;

  TCBBaseInfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBBaseInfo: TACBBaseInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBBaseInfo(const Value: TACBBaseInfo);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Procedure AppendAID(Const ID:String);
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBBaseInfo : TACBBaseInfo read FACBBaseInfo write SetACBBaseInfo;
  End;

  TACBBaseInfoFrm = class(TFrame)
    Panel_Left: TPanel;
    Panel_Right: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
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
    Btn_Refresh: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Insert: TSpeedButton;
    Btn_MoveUp: TSpeedButton;
    Btn_MoveDwn: TSpeedButton;
    Btn_Add: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Panel_Memo: TPanel;
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
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure ListValueEditChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    ACBBaseInfoMgr : TCBBaseInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    Procedure ResetNum();
    Procedure DeleteAData();
    Procedure InsertAData();
    Procedure AddAData();
    Procedure MoveUp();
    Procedure MoveDwn();
    procedure Init(Const FileName:String);

  public
    { Public declarations }
    FEditEnabled:Boolean;//add by wangjinhua 20090626 Doc4.3

    Procedure SetDefaultColumnData();
    Procedure CreateDefaultData();
    Procedure SaveDocData();
    Procedure LoadDocData();
    Procedure ShowLoadDocData();
    Procedure SetInit(Parent:TWinControl;Const FileName:String);
    Function GetMemoText():String;
    Procedure Refresh(Const FileName:String);
    Function NeedSave():Boolean;
    Procedure BeSave();
    procedure RefID();
  end;

Var
  DefaultDataLst : Array of String;
  DEFAULT_IDNAME : String;


implementation

{$R *.dfm}

{ TACBDocFrm }

procedure TACBBaseInfoFrm.Init(Const FileName:String);
Var
  i : Integer;
  ABaseInfo  : TACBBaseInfo;
begin

   FLockMemoChange := True;


   ListValue.ClearNodes;


    if Not Assigned(ACBBaseInfoMgr) Then
      ACBBaseInfoMgr := TCBBaseInfoMgr.Create(FileName);

   //檢查有否預設的欄位,如果沒有就新增預設
   ACBBaseInfoMgr.ReadDocDat(DEFAULT_IDNAME);
   if High(ACBBaseInfoMgr.ACBBaseInfo.HolderLst)=-1 Then
   Begin
      SetDefaultColumnData;
      ABaseInfo  := ACBBaseInfoMgr.ACBBaseInfo;
      SetLength(ABaseInfo.HolderLst,High(DefaultDataLst)+1);
      For i:=0 to High(ABaseInfo.HolderLst) do
      Begin
        With  ABaseInfo Do
        Begin
          HolderLst[i].Value[0] := DefaultDataLst[i];
          HolderLst[i].Value[1] := '';
        End;
      End;
      ACBBaseInfoMgr.ACBBaseInfo := ABaseInfo;
   End Else
   Begin
      //如果修改的是預設的,則自動將預設欄位更正
      ABaseInfo  := ACBBaseInfoMgr.ACBBaseInfo;
      SetLength(DefaultDataLst,High(ABaseInfo.HolderLst)+1);
      For i:=0 to High(ABaseInfo.HolderLst) do
          DefaultDataLst[i] := ABaseInfo.HolderLst[i].Value[0];
    End;
   ////////////////////////////////////

   BeSave;

   List_ID.Clear;
   For i:=0 to ACBBaseInfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBBaseInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;


end;

procedure TACBBaseInfoFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBBaseInfoMgr.ReadDocDat(ID);

  //预设欄位不能修改或删除
  SpeedButton2.Enabled := (FEditEnabled or
                          not InRightList(SpeedButton2.Caption)) and
                          (ID<>DEFAULT_IDNAME);
  SpeedButton3.Enabled := (FEditEnabled  or
                          not InRightList(SpeedButton3.Caption)) and
                          (ID<>DEFAULT_IDNAME);
  Btn_MoveUp.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveUp.Caption));
  Btn_MoveDwn.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveDwn.Caption));
  Column_A2.Visible := ID<>DEFAULT_IDNAME
  ////////////////////////////////////////

end;

procedure TACBBaseInfoFrm.SetInit(Parent: TWinControl;Const FileName:String);
begin

    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');
    Btn_Delete.Caption  := FAppParam.ConvertString('>>删除');
    Btn_Insert.Caption  := FAppParam.ConvertString('>>插入');
    Btn_Add.Caption  := FAppParam.ConvertString('>>新增');
    Btn_MoveUp.Caption  := FAppParam.ConvertString('>>上移');
    Btn_MoveDwn.Caption  := FAppParam.ConvertString('>>下移');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入标的股票代码');

    DEFAULT_IDNAME :=  FAppParam.ConvertString('预设的字段设定');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('标题');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('内容');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBBaseInfoFrm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ID:String;
begin

    FLockMemoChange := True;
Try


   if High(ACBBaseInfoMgr.ACBBaseInfo.HolderLst)>=0 Then
      ListValue.ClearNodes
   Else
      CreateDefaultData;


   For i:=0 to High(ACBBaseInfoMgr.ACBBaseInfo.HolderLst) do
   Begin
     AItem :=  ListValue.Add;
     With  ACBBaseInfoMgr.ACBBaseInfo Do
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
       AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := HolderLst[i].Value[0];
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := HolderLst[i].Value[1];
     End;
   End;

  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  SpeedButton2.Enabled := (FEditEnabled or
                          not InRightList(SpeedButton2.Caption)) and
                          (ID<>DEFAULT_IDNAME);
  SpeedButton3.Enabled := (FEditEnabled  or
                          not InRightList(SpeedButton3.Caption)) and
                          (ID<>DEFAULT_IDNAME);
  Btn_MoveUp.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveUp.Caption));
  Btn_MoveDwn.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveDwn.Caption));
  Column_A2.Visible := ID<>DEFAULT_IDNAME
Finally
   FLockMemoChange := false;
End;

end;

procedure TACBBaseInfoFrm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ABaseInfo  : TACBBaseInfo;
begin
Try

   ABaseInfo  := ACBBaseInfoMgr.ACBBaseInfo;

   SetLength(ABaseInfo.HolderLst,ListValue.Count);


   For i:=0 to High(ABaseInfo.HolderLst) do
   Begin
     AItem :=  ListValue.Items[i];
     With  ABaseInfo Do
     Begin
        HolderLst[i].Value[0] := AItem.Strings[ListValue.ColumnByName('Column_A1').Index];
        HolderLst[i].Value[1] := AItem.Strings[ListValue.ColumnByName('Column_A2').Index];
     End;
   End;

    ACBBaseInfoMgr.ACBBaseInfo := ABaseInfo;

    //如果修改的是預設的,則自動將預設欄位更正
    if ACBBaseInfoMgr.FNowID=DEFAULT_IDNAME Then
    Begin
       SetLength(DefaultDataLst,High(ABaseInfo.HolderLst)+1);
       For i:=0 to High(ABaseInfo.HolderLst) do
          DefaultDataLst[i] := ABaseInfo.HolderLst[i].Value[0];
    End;


    FHaveChangeData := false;


Finally
End;

end;

function TACBBaseInfoFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ACBBaseInfoMgr) Then
     Result := ACBBaseInfoMgr.GetMemoText;

end;

{ TCBBaseInfoMgr }

procedure TCBBaseInfoMgr.AppendAID(const ID: String);
Var
  i : Integer;
begin
   i := High(FIDLst)+1;
   SetLength(FIDLst,i+1);
   FIDLst[i] := ID;
   ReadDocDat(ID);
end;

constructor TCBBaseInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBBaseInfoMgr.CreateAID(var ID: String): Boolean;
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

function TCBBaseInfoMgr.DelAID: Boolean;
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
        Break;
      End;
   End;

Except
End;
Finally
     f.Free;
End;



end;

destructor TCBBaseInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBBaseInfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBBaseInfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBBaseInfoMgr.GetMemoText: String;
begin
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

procedure TCBBaseInfoMgr.Init;
Var
  i,j : Integer;
  Str : String;
  IDLst : Array of String;
begin

try
try

   FNeedSave := False;

   FFileMemo.LoadFromFile(FFileName);

   SetLength(IDLst,0);

   For i:=0 to FFileMemo.Count-1 do
   Begin
       if (Pos('[',FFileMemo.Strings[i])>0) and
          (Pos(']',FFileMemo.Strings[i])>0) Then
       Begin
          if '['+DEFAULT_IDNAME+']'<> FFileMemo.Strings[i] Then
          Begin
            Str := Trim(FFileMemo.Strings[i]);
            ReplaceSubString('[','',Str);
            ReplaceSubString(']','',Str);
            j := High(IDLst)+1;
            SetLength(IDLst,j+1);
            IDLst[j] := Str;
          End;
       End;
   End;

   SortIDLst(IDLst);

   SetLength(FIDLst,High(IDLst)+2);
   FIDLst[0] := DEFAULT_IDNAME;
   For i:=1 to High(IDLst)+1 do
      FIDLst[i] := IDLst[i-1];




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


procedure TCBBaseInfoMgr.ReadDocDat(const ID: String);
Var
  f : TIniFile;
  Str : String;
  StrLst:_CStrLst2;
  Count,i : integer;

Begin

  SaveDocDat;

  Setlength(StrLst,0);

  f := TIniFile.Create(FFileName);

  FNowID := ID;

  Try
  Try

  Count := f.ReadInteger(ID,'Count',0);
  SetLength(FACBBaseInfo.HolderLst,Count);

  For i:=0 to High(FACBBaseInfo.HolderLst) Do
  Begin
      FACBBaseInfo.HolderLst[i].Value[0] := '';
      FACBBaseInfo.HolderLst[i].Value[1] := '';
      Str := f.ReadString(ID,IntToStr(i+1),'');
      //SetLength(StrLst,0);
      StrLst := DoStrArray2(Str,';');
      if High(StrLst)=1 Then
      Begin
        FACBBaseInfo.HolderLst[i].Value[0] := StrLst[0];
        FACBBaseInfo.HolderLst[i].Value[1] := StrLst[1];
      End;
  End;

  Except
  End;
  Finally
     f.Free;
  End;





end;

procedure TCBBaseInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBBaseInfoMgr.SaveDocDat;
Var
  f : TIniFile;
  Str : String;
  i,j,c : integer;
Begin

  if Length(FNowID)=0 Then
     Exit;

  if not FNeedSave Then
     Exit;

  f := TIniFile.Create(FFileName);

  Try
  Try
  c := 0;
  f.EraseSection(FNowID);
  f.WriteInteger(FNowID,'Count',0);
  For i:=0 to High(FACBBaseInfo.HolderLst) Do
  Begin

      For j:=0 to High(FACBBaseInfo.HolderLst[i].Value) do
      Begin
        Str := Trim(FACBBaseInfo.HolderLst[i].Value[j]);
        ReplaceSubString(';','',Str);
        FACBBaseInfo.HolderLst[i].Value[j] := Str;
      End;

      if Length(FACBBaseInfo.HolderLst[i].Value[0])>0 Then
      Begin
        Str := Format('%s;%s',
               [FACBBaseInfo.HolderLst[i].Value[0],
                FACBBaseInfo.HolderLst[i].Value[1]]);
        f.WriteString(FNowID,IntToStr(c+1),Str);
        inc(c);
      End;
  End;
  f.WriteInteger(FNowID,'Count',c);

  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;

end;


procedure TACBBaseInfoFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBBaseInfoFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBBaseInfoFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TCBBaseInfoMgr.SetACBBaseInfo(
  const Value: TACBBaseInfo);
begin
  FACBBaseInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBBaseInfoFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  ListValue.FocusedColumn<>0;
end;

procedure TACBBaseInfoFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBBaseInfoFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
 if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBBaseInfoFrm.DeleteAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;
    if Not Assigned(AItem) Then
       Exit;

   AItem.Free;

   ResetNum;

end;

procedure TACBBaseInfoFrm.InsertAData;
Var
 AItem : TdxTreeListNode;
begin
    AItem := ListValue.FocusedNode;

    {if Assigned(AItem) Then
      if AItem.Index<ListValue.Count-1 Then
         AItem := ListValue.Items[AItem.Index+1]
      Else
         AItem := nil;
    }
    if Assigned(AItem) Then
    Begin
      ListValue.Insert(AItem);
    End Else
      ListValue.Add; 


   ResetNum;


end;

procedure TACBBaseInfoFrm.MoveDwn;
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

procedure TACBBaseInfoFrm.MoveUp;
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

procedure TACBBaseInfoFrm.ResetNum;
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

procedure TACBBaseInfoFrm.Refresh(const FileName: String);
begin
   ACBBaseInfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBBaseInfoFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBBaseInfoFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBBaseInfoFrm.Btn_DeleteClick(Sender: TObject);
begin
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  Begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3 
    DeleteAData;
    SaveDocData;
  End;
end;

procedure TACBBaseInfoFrm.Btn_InsertClick(Sender: TObject);
begin
   InsertAData;
end;

procedure TACBBaseInfoFrm.Btn_MoveUpClick(Sender: TObject);
begin
 MoveUp;
 WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
 SaveDocData;
end;

procedure TACBBaseInfoFrm.Btn_MoveDwnClick(Sender: TObject);
begin
  MoveDwn;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
end;

procedure TACBBaseInfoFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBBaseInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBBaseInfoFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBBaseInfoMgr.FNowID=DEFAULT_IDNAME Then
   Begin
      ShowMessage(FAppParam.ConvertString('预设不能修改或删除'));
      Exit;
   End;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBBaseInfoMgr.DelAID() Then
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


end;

procedure TACBBaseInfoFrm.AddAData;
begin
   ListValue.Add;
   ResetNum;
end;

procedure TACBBaseInfoFrm.Btn_AddClick(Sender: TObject);
begin
  AddAData;
end;

procedure TACBBaseInfoFrm.Txt_IDChange(Sender: TObject);
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

function TACBBaseInfoFrm.NeedSave: Boolean;
begin
   Result := ACBBaseInfoMgr.FNeedSaveUpload;
end;

procedure TACBBaseInfoFrm.BeSave;
begin

 ACBBaseInfoMgr.FNeedSaveUpload := False;

end;

procedure TACBBaseInfoFrm.CreateDefaultData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin

    FLockMemoChange := True;
Try



   ListValue.ClearNodes;

   For i:=0 to High(DefaultDataLst) do
   Begin
     AItem :=  ListValue.Add;
     With  ACBBaseInfoMgr.ACBBaseInfo Do
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
       AItem.Strings[ListValue.ColumnByName('Column_A1').Index] :=
                    FAppParam.ConvertString(DefaultDataLst[i]);
     End;
   End;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBBaseInfoFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData := True;
end;

function TCBBaseInfoMgr.UpdateAID(Var ID: String): Boolean;
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

procedure TACBBaseInfoFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBBaseInfoMgr.FNowID=DEFAULT_IDNAME Then
   Begin
      ShowMessage(FAppParam.ConvertString('预设不能修改或删除'));
      Exit;
   End;
      
   if ACBBaseInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

procedure TACBBaseInfoFrm.SetDefaultColumnData;
begin

   SetLength(DefaultDataLst,12);
   DefaultDataLst[0] := '股票名称';
   DefaultDataLst[1] := '股票代码';
   DefaultDataLst[2] := '公司名称';
   DefaultDataLst[3] := '法人代表';
   DefaultDataLst[4] := '注册时间';
   DefaultDataLst[5] := '注册地址';
   DefaultDataLst[6] := '联系电话';
   DefaultDataLst[7] := '联系人';
   DefaultDataLst[8] := '上市地点';
   DefaultDataLst[9] := '上市日期';
   DefaultDataLst[10] := '行业类别';
   DefaultDataLst[11] := '经营范围';

end;

procedure TACBBaseInfoFrm.RefID;
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

end.
