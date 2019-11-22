unit CBBondFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,TCBDatEditUnit,
  dxTLClms,TDocMgr;

type

  //发行日,到期日,债券期限,债券利率,付息
  TABondInfo=Record
     IDate,LDate : TDate;
     S1 : Array[0..2] of Double;
  End;

  TBondInfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FABondInfo: TABondInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetABondInfo(const Value: TABondInfo);
    Function DateStrToDate(Str:String):TDate;
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    procedure DelDocDat();
    Function UpdateAID(Var ID:String):Boolean;
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ABondInfo : TABondInfo read FABondInfo write SetABondInfo;
  End;

  TACBBondFrm = class(TFrame)
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
    ABondInfoMgr : TBondInfoMgr;
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

procedure TACBBondFrm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;

   CreateDefauleItem;


   if Not Assigned(ABondInfoMgr) Then
      ABondInfoMgr := TBondInfoMgr.Create(FileName);

   BeSave;
   
   List_ID.Clear;
   For i:=0 to ABondInfoMgr.IDCount-1 do
       List_ID.Items.Add(ABondInfoMgr.ID[i]);

   FLockMemoChange := false;
   
   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBBondFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ABondInfoMgr.ReadDocDat(ID);
end;

procedure TACBBondFrm.SetInit(Parent: TWinControl;Const FileName:String);
begin

    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('标题');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('内容');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBBondFrm.ShowLoadDocData;
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
     With  ABondInfoMgr.ABondInfo Do
     Begin
       Case i of
         0: Str := FormatDateTime('yyyy-mm-dd',IDate);
         1: Str := FormatDateTime('yyyy-mm-dd',LDate);
         2: Str := FloatToStr(S1[0]);
         3: Str := FloatToStr(S1[1]);
         4: Str := FloatToStr(S1[2]);
       End;
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := Str;
     End;
   End;


Finally
   FLockMemoChange := false;
   //刷新的動作,可以刷新斷行的出現
   ListValue.Width := ListValue.Width-1;
End;

end;

procedure TACBBondFrm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TABondInfo;
  Str : String;
begin

Try

   ADateInfo  := ABondInfoMgr.ABondInfo;


   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  ADateInfo Do
     Begin
         //BaseDate := -1;
         Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
         if (i>=2) and (i<=4) Then
         Begin
             Str := ReplaceNumString(Str);
             if Not isInteger(PChar(Str)) Then
                 Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));
         End Else
         Begin
           if Not IsDate(Str) Then
              Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
         End;

         Case i  of
            0 : IDate := StrToDate(Str);
            1 : LDate := StrToDate(Str);
            2 : S1[0] := StrToFloat(Str);
            3 : S1[1] := StrToFloat(Str);
            4 : S1[2] := StrToFloat(Str);
         End;
     End;
   End;

   ABondInfoMgr.ABondInfo := ADateInfo;

   FHaveChangeData := False;


Finally
End;

end;

function TACBBondFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ABondInfoMgr) Then
     Result := ABondInfoMgr.GetMemoText;  

end;

{ TBondInfoMgr }

constructor TBondInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TBondInfoMgr.CreateAID(var ID: String): Boolean;
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
   With  FABondInfo do
   Begin
        FFileMemo.Add(Format('ID=%s,%s,%s,%s,%s,%s',
                                         [ID,
                                          FormatDateTime('yyyymmdd',IDate),
                                          FormatDateTime('yyyymmdd',LDate),
                                          FloatToStr(S1[0]),
                                          FloatToStr(S1[1]),
                                          FloatToStr(S1[2])]));
   End;



   Result := True;


end;

function TBondInfoMgr.DateStrToDate(Str: String): TDate;
begin
    Result := -1;
    if Length(Str)<8 Then
      Exit;
    Str := Copy(Str,1,4)+'-'+Copy(Str,5,2)+'-'+Copy(Str,7,2);
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
    Result := StrToDate2(Str);
end;

function TBondInfoMgr.DelAID: Boolean;
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
        Break;
      End;
   End;

Except
End;
Finally
End;

end;

procedure TBondInfoMgr.DelDocDat;
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

destructor TBondInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TBondInfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TBondInfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TBondInfoMgr.GetMemoText: String;
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
   for i:=0 to  FFileMemo.Count-1 do
   Begin
       Str := FFileMemo.Strings[i];
       ReplaceSubString('ID=','',Str);
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

procedure TBondInfoMgr.Init;
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
     Str := Trim(f.Strings[i]);
     if Length(Str)>0 Then
        FFileMemo.Add(Str);
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


procedure TBondInfoMgr.ReadDocDat(const ID: String);
Var
  Str : String;
  StrLst:_CStrLst2;
  i,j : integer;
Begin

  SaveDocDat;

  FNowID := ID;
  With FABondInfo Do
  Begin
    IDate := 0;
    LDate := 0;
    For j:=0 to High(S1) do
       S1[j] := 0;
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
        With FABondInfo Do
        Begin
            IDate := DateStrToDate(StrLst[1]);
            LDate := DateStrToDate(StrLst[2]);
            For j:=3 to High(StrLst) do
              S1[j-3] := StrToFloat(StrLst[j]);
        End;
        Break;
      End;
   End;
  Except
  End;
  Finally
  End;





end;

procedure TBondInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TBondInfoMgr.SaveDocDat;
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
        With  FABondInfo do
        Begin
          FFileMemo.Strings[i] := Format('ID=%s,%s,%s,%s,%s,%s',
                                         [FNowID,
                                          FormatDateTime('yyyymmdd',IDate),
                                          FormatDateTime('yyyymmdd',LDate),
                                          FloatToStr(S1[0]),
                                          FloatToStr(S1[1]),
                                          FloatToStr(S1[2])]);
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


procedure TACBBondFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBBondFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBBondFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TBondInfoMgr.SetABondInfo(
  const Value: TABondInfo);
begin
  FABondInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBBondFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0) and
             (ListValue.FocusedColumn<>1) ;
end;

procedure TACBBondFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBBondFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
 if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;

end;

procedure TACBBondFrm.CreateDefauleItem;
procedure CreateItem(Str:String);
Var
  AItem : TdxTreeListNode;
begin
   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(ListValue.Count);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := Str;
End;
begin

  ListValue.ClearNodes;


  CreateItem(FAppParam.ConvertString('发行日'));
  CreateItem(FAppParam.ConvertString('到期日'));
  CreateItem(FAppParam.ConvertString('债券期限'));
  CreateItem(FAppParam.ConvertString('债券利率'));
  CreateItem(FAppParam.ConvertString('付息(1.每年 2.到期)'));


end;

procedure TACBBondFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBBondFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBBondFrm.Refresh(const FileName: String);
begin
   ABondInfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBBondFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ABondInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBBondFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ABondInfoMgr.DelAID() Then
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

procedure TACBBondFrm.Txt_IDChange(Sender: TObject);
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

function TACBBondFrm.NeedSave: Boolean;
begin
   Result := ABondInfoMgr.FNeedSaveUpload;
end;

procedure TACBBondFrm.BeSave;
begin
  ABondInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBBondFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData := True;
end;

function TBondInfoMgr.UpdateAID(var ID: String): Boolean;
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

procedure TACBBondFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;
      
   if ABondInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

procedure TACBBondFrm.RefID;
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
