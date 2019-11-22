unit CBIssue2Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,TCBDatEditUnit,
  dxTLClms,TDocMgr;

type

  //信用等級,主承销商,副承销商,担保人,
  //原有股东,申购金额,占发行量,配售比例
  //网上,申购金额,占发行量,配售比例
  //网下,申购金额,定金比例,占发行量,配售比例
  TACBIssueInfo=Record
     S1 : Array[0..16] of String;
  End;

  TCBIssueInfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBIssueInfo: TACBIssueInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBIssueInfo(const Value: TACBIssueInfo);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    procedure DelDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBIssueInfo : TACBIssueInfo read FACBIssueInfo write SetACBIssueInfo;
  End;

  TACBIssue2Frm = class(TFrame)
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
    Column_A2: TdxTreeListWrapperColumn;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    Colume_Color: TdxTreeListColumn;
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
  private
    { Private declarations }
    ACBIssueInfoMgr : TCBIssueInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    Procedure CreateDefauleItem();
    procedure Init(Const FileName:String);

  public
    { Public declarations }
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


implementation

{$R *.dfm}

{ TACBDocFrm }

procedure TACBIssue2Frm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;

   CreateDefauleItem;


   if Not Assigned(ACBIssueInfoMgr) Then
      ACBIssueInfoMgr := TCBIssueInfoMgr.Create(FileName);

   BeSave;
   
   List_ID.Clear;
   For i:=0 to ACBIssueInfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBIssueInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex :=GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBIssue2Frm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBIssueInfoMgr.ReadDocDat(ID);
end;

procedure TACBIssue2Frm.SetInit(Parent: TWinControl;Const FileName:String);
begin

    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('标题');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('内容');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBIssue2Frm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin

    FLockMemoChange := True;
Try

   ListValue.ClearNodes;

   CreateDefauleItem;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  ACBIssueInfoMgr.ACBIssueInfo Do
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] :=S1[i];
     End;
   End;


Finally
   FLockMemoChange := false;
   //刷新的動作,可以刷新斷行的出現
   ListValue.Width := ListValue.Width-1;
End;

end;

procedure TACBIssue2Frm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TACBIssueInfo;
  Str : String;
begin

Try

   ADateInfo  := ACBIssueInfoMgr.ACBIssueInfo;


   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  ADateInfo Do
     Begin
         //BaseDate := -1;
         Str := ReplaceNumString(Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]));
         if i>3 Then
         Begin
            if (Length(Str)>0) and (UpperCase(Str)<>'NA') Then
            Begin
               if Not IsInteger(PChar(Str)) Then
                  Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));
            End;
         End;
         S1[i] := Str;
     End;
   End;

    ACBIssueInfoMgr.ACBIssueInfo := ADateInfo;

    FHaveChangeData := False;


Finally
End;

end;

function TACBIssue2Frm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ACBIssueInfoMgr) Then
     Result := ACBIssueInfoMgr.GetMemoText;

end;

{ TCBIssueInfoMgr }

constructor TCBIssueInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBIssueInfoMgr.CreateAID(var ID: String): Boolean;
Var
  Str1,Str : String;
  i,j : Integer;
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
   With  FACBIssueInfo do
   Begin
       For j:=0 to High(S1) do
       Begin
            Str := Trim(S1[j]);
            ReplaceSubString(',','',Str);
            if (j>2) Then
            Begin
              if Not IsInteger(PChar(Str)) Then
                 Str:='na';
            End;
            S1[j] := Str
       End;
       For j:=0 to High(S1) do
       Begin
             if j=0 Then
               Str1 := S1[j]
             Else
               Str1 := Str1+','+S1[j];
        End;
        FFileMemo.Add(Format('ID=%s,%s',[ID,Str1]));
   End;



   Result := True;

end;


function TCBIssueInfoMgr.DelAID: Boolean;
Var
  i,j : Integer;
  ID : String;
begin

   Result := False;

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
        DelDocDat;
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

procedure TCBIssueInfoMgr.DelDocDat;
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

destructor TCBIssueInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBIssueInfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBIssueInfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBIssueInfoMgr.GetMemoText: String;
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
   f.Add('[ISSUE]');
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

procedure TCBIssueInfoMgr.Init;
Var
  i,j,p1,p2 : Integer;
  f : TStringList;
  Str : String;
begin

   f := nil;
try
try

   FNeedSave := False;

   SetLength(FIDLst,0);
   FFileMemo.Clear;

   f := TStringList.Create;
   f.LoadFromFile(FFileName);

   For i:=0 to f.Count-1 Do
   Begin
     if (Pos('=',f.Strings[i])>0) Then
     Begin
        p1  := Pos('=',f.Strings[i]);
        p2  := Length(f.Strings[i]);
        Str := Copy(f.Strings[i],p1+1,p2-p1+1);
        FFileMemo.Add(Str);
     End;
   End;

   f.Clear;

   For i:=0 to FFileMemo.Count-1 do
   Begin
        Str := Trim(FFileMemo.Strings[i]);
        p1 := 1;
        p2 := Pos(',',FFileMemo.Strings[i]);
        Str := Copy(FFileMemo.Strings[i],p1,p2-p1);
        j := High(FIDLst)+1;
        SetLength(FIDLst,j+1);
        FIDLst[j] := Str;
        FFileMemo.Strings[i] := 'ID='+FFileMemo.Strings[i];
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
  if Assigned(f) Then
     f.Free;
End;


end;


procedure TCBIssueInfoMgr.ReadDocDat(const ID: String);
Var
  Str : String;
  StrLst:_CStrLst2;
  i,j : integer;
Begin

  SaveDocDat;

  FNowID := ID;
  With FACBIssueInfo Do
    For j:=0 to High(S1) do
       S1[j] := '';

  Try
  Try
   For i:=0 to FFileMemo.Count-1 do
   Begin
      Str := Trim(FFileMemo.Strings[i]);
      if Pos('ID='+FNowID,Str)>0 Then
      Begin
        SetLength(StrLst,0);
        StrLst := DoStrArray2(Str,',');
        With FACBIssueInfo Do
        Begin
          For j:=0 to High(S1) do
             S1[j] := StrLst[1+j];
        End;
        Break;
      End;
   End;
  Except
  End;
  Finally
  End;





end;

procedure TCBIssueInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBIssueInfoMgr.SaveDocDat;
Var
  Str1,Str : String;
  i,j : Integer;
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
        With  FACBIssueInfo do
        Begin

          For j:=0 to High(S1) do
          Begin
            Str := Trim(S1[j]);
            ReplaceSubString(',','',Str);
            if (j>3) Then
            Begin
              if Not IsInteger(PChar(Str)) Then
                 Str:='na';
            End;
            S1[j] := Str
          End;
          For j:=0 to High(S1) do
          Begin
             if j=0 Then
               Str1 := S1[j]
             Else
               Str1 := Str1+','+S1[j];
          End;
          FFileMemo.Strings[i] := Format('ID=%s,%s',
                                         [FNowID,Str1]);
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


procedure TACBIssue2Frm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBIssue2Frm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBIssue2Frm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TCBIssueInfoMgr.SetACBIssueInfo(
  const Value: TACBIssueInfo);
begin
  FACBIssueInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBIssue2Frm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0) and
             (ListValue.FocusedColumn<>1) ;
end;

procedure TACBIssue2Frm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBIssue2Frm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBIssue2Frm.CreateDefauleItem;
procedure CreateItem(Color:Integer;Str:String);
Var
  AItem : TdxTreeListNode;
begin
   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Colume_Color').Index] := IntToStr(Color);
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(ListValue.Count);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString(Str);
End;
begin
   ListValue.ClearNodes;


  CreateItem(0,'信用等级');
  CreateItem(0,'主承销商');
  CreateItem(0,'副承销商');
  CreateItem(0,'担保人');
  CreateItem(1,'原有股东(1.有 0.无)');
  CreateItem(1,'申购金额(原有股东)(万元)');
  CreateItem(1,'占发行量(原有股东)');
  CreateItem(1,'配售比例(原有股东)');
  //CreateItem('定金比例(原有股东)');
  CreateItem(0,'网上(1.有 0.无)');
  CreateItem(0,'申购金额(网上)(万元)');
  CreateItem(0,'占发行量(网上)');
  CreateItem(0,'配售比例(网上)');
  //CreateItem('定金比例(网上)');
  CreateItem(1,'网下(1.有 0.无)');
  CreateItem(1,'申购金额(网下)(万元)');
  CreateItem(1,'定金比例(网下)');
  CreateItem(1,'占发行量(网下)');
  CreateItem(1,'配售比例(网下)');


end;

procedure TACBIssue2Frm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin

  if Not ASelected Then
  if ANode.Strings[0]='1' Then
  Begin
      AColor := clSilver;
  End;

  if  ( AColumn.Index=0) or
      ( AColumn.Index=1) Then
  Begin
      AColor := $0080FFFF;
      AFont.Color := clBlack;
  end;


end;

procedure TACBIssue2Frm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBIssue2Frm.Refresh(const FileName: String);
begin
   ACBIssueInfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBIssue2Frm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin
   if ACBIssueInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;
end;

procedure TACBIssue2Frm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin
Try
   if List_ID.ItemIndex<0 Then
      exit;
   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;
   if ACBIssueInfoMgr.DelAID() Then
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
        LoadDocData;
        ShowLoadDocData;
      End;
   End;
Finally
End;


end;

procedure TACBIssue2Frm.Txt_IDChange(Sender: TObject);
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

function TACBIssue2Frm.NeedSave: Boolean;
begin
   Result := ACBIssueInfoMgr.FNeedSaveUpload;
end;

procedure TACBIssue2Frm.BeSave;
begin
  ACBIssueInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBIssue2Frm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData := True;
end;

function TCBIssueInfoMgr.UpdateAID(var ID: String): Boolean;
Var
 i,j : Integer;
 Str : String;
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

        For j:=0 to FFileMemo.Count-1 do
        Begin
          Str := Trim(FFileMemo.Strings[j]);
          if Pos('ID='+FNowID,Str)>0 Then
          Begin
            FIDLst[i] := ID;
            ReplaceSubString('ID='+FNowID,'ID='+ID,Str);
            FFileMemo.Strings[j] := Str;
            FNowID := ID;
            FNeedSave := False;
            FNeedSaveUpload := True;
            Break;
          End;
        End;
        Break;
     End;

   Result := True;
end;

procedure TACBIssue2Frm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBIssueInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

procedure TACBIssue2Frm.RefID;
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
