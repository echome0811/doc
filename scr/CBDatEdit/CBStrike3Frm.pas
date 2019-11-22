{*****************************************************************************
 创建标示：CBStrike3Frm2.0.0.0-Doc2.3.0.0-需求6-libing-2007/09/20-修改
 功能标示：输入多个交易日用顿号隔开
*****************************************************************************}
unit CBStrike3Frm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr;

type

  TAStrike3Info=Record
     Days : String;
     Per  : Double;
  End;

  TStrike3InfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FAStrike3Info: TAStrike3Info;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetAStrike3Info(const Value: TAStrike3Info);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    Function UpdateAID(Var ID:String):Boolean;
    procedure DelDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property AStrike3Info : TAStrike3Info read FAStrike3Info write SetAStrike3Info;
  End;

  TACBStrike3Frm = class(TFrame)
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
    AStrike3InfoMgr : TStrike3InfoMgr;
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

procedure TACBStrike3Frm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;

   CreateDefauleItem;


   if Not Assigned(AStrike3InfoMgr) Then
      AStrike3InfoMgr := TStrike3InfoMgr.Create(FileName);
      
   BeSave;

   List_ID.Clear;
   For i:=0 to AStrike3InfoMgr.IDCount-1 do
       List_ID.Items.Add(AStrike3InfoMgr.ID[i]);

   FLockMemoChange := false;
   
   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBStrike3Frm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  AStrike3InfoMgr.ReadDocDat(ID);
end;

procedure TACBStrike3Frm.SetInit(Parent: TWinControl;Const FileName:String);
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

procedure TACBStrike3Frm.ShowLoadDocData;
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
     With  AStrike3InfoMgr.AStrike3Info Do
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

procedure TACBStrike3Frm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TAStrike3Info;
  Str: String;
begin
Try
   ADateInfo  := AStrike3InfoMgr.AStrike3Info;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  ADateInfo Do
     Begin
        //BaseDate := -1;
        Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
        Str := ReplaceNumString(Str);// CBStrike3Frm2.0.0.0-Doc2.3.0.0-需求6-libing-2007/09/20-修改
       // if Not isInteger(PChar(Str1)) Then                 by  leon 0912
          //  Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));

         Case i of
            0: Days := Str;
            1: Per := StrToFloat(Str);
        End;
     End;
   End;

    AStrike3InfoMgr.AStrike3Info := ADateInfo;

    FHaveChangeData := False;

Finally
End;

end;

function TACBStrike3Frm.GetMemoText: String;
begin

  if FHaveChangeData Then
  SaveDocData;

  Result := '';
  if Assigned(AStrike3InfoMgr) Then
     Result := AStrike3InfoMgr.GetMemoText;  

end;

{ TStrike3InfoMgr }

constructor TStrike3InfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TStrike3InfoMgr.CreateAID(var ID: String): Boolean;
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
   With  FAStrike3Info do
         FFileMemo.Add(Format('ID=%s,%s,%s',
                             [ID,Days,FloatToStr(Per)]));


   Result := True;



end;


function TStrike3InfoMgr.DelAID: Boolean;
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

procedure TStrike3InfoMgr.DelDocDat;
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

destructor TStrike3InfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TStrike3InfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TStrike3InfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TStrike3InfoMgr.GetMemoText: String;
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

procedure TStrike3InfoMgr.Init;
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


procedure TStrike3InfoMgr.ReadDocDat(const ID: String);
Var
  Str : String;
  StrLst:_CStrLst2;
  i : integer;
Begin

  SaveDocDat;

  FNowID := ID;
  With FAStrike3Info Do
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
        With FAStrike3Info Do
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

procedure TStrike3InfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TStrike3InfoMgr.SaveDocDat;
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
        With  FAStrike3Info do
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


procedure TACBStrike3Frm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBStrike3Frm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBStrike3Frm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TStrike3InfoMgr.SetAStrike3Info(
  const Value: TAStrike3Info);
begin
  FAStrike3Info := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBStrike3Frm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0) and
             (ListValue.FocusedColumn<>1) ;
end;

procedure TACBStrike3Frm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBStrike3Frm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBStrike3Frm.CreateDefauleItem;
Var
  AItem : TdxTreeListNode;
begin
   ListValue.ClearNodes;

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(1);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('交易日数');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(2);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('上浮幅度');
end;

procedure TACBStrike3Frm.ListValueCustomDrawCell(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; ANode: TdxTreeListNode;
  AColumn: TdxTreeListColumn; ASelected, AFocused, ANewItemRow: Boolean;
  var AText: String; var AColor: TColor; AFont: TFont;
  var AAlignment: TAlignment; var ADone: Boolean);
begin

  if  ( AColumn.Index=0) or
             ( AColumn.Index=1) Then
  Begin
      AColor := $0080FFFF;
      AFont.Color := clBlack;
  end;

end;

procedure TACBStrike3Frm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBStrike3Frm.Refresh(const FileName: String);
begin
   AStrike3InfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBStrike3Frm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if AStrike3InfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;
end;

procedure TACBStrike3Frm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if AStrike3InfoMgr.DelAID() Then
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

procedure TACBStrike3Frm.Txt_IDChange(Sender: TObject);
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

function TACBStrike3Frm.NeedSave: Boolean;
begin
   Result := AStrike3InfoMgr.FNeedSaveUpload
end;

procedure TACBStrike3Frm.BeSave;
begin

  AStrike3InfoMgr.FNeedSaveUpload := False;
end;

procedure TACBStrike3Frm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData :=  True;
end;

function TStrike3InfoMgr.UpdateAID(var ID: String): Boolean;
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

procedure TACBStrike3Frm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin
   if List_ID.ItemIndex<0 Then
      exit;

   if AStrike3InfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;
end;

procedure TACBStrike3Frm.RefID;
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
