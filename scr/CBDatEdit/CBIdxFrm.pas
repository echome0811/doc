unit CBIdxFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr;

type

  TAIdxInfo=Record
    ADate : TDate;
    Value : Double;
  End;

  TACBIdxInfo=Record
     HolderLst : Array of TAIdxInfo;
  End;

  TCBIdxInfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBIdxInfo: TACBIdxInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    procedure SortInfoDate();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBIdxInfo(const Value: TACBIdxInfo);
    Function DateStrToDate(Str:String):TDate;
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBIdxInfo : TACBIdxInfo read FACBIdxInfo write SetACBIdxInfo;
  End;

  TACBIdxFrm = class(TFrame)
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
    Btn_Refresh: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Insert: TSpeedButton;
    Btn_MoveUp: TSpeedButton;
    Btn_MoveDwn: TSpeedButton;
    Bevel5: TBevel;
    Btn_Add: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
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
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_InsertClick(Sender: TObject);
    procedure Btn_MoveUpClick(Sender: TObject);
    procedure Btn_MoveDwnClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure ListValueEditChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    ACBIdxInfoMgr : TCBIdxInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    Procedure ResetNum();
    Procedure DeleteAData();
    Procedure InsertAData();
    Procedure MoveUp();
    Procedure MoveDwn();
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

procedure TACBIdxFrm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;


   ListValue.ClearNodes;


   if Not Assigned(ACBIdxInfoMgr) Then
      ACBIdxInfoMgr := TCBIdxInfoMgr.Create(FileName);

   BeSave;
   
   List_ID.Clear;
   For i:=0 to ACBIdxInfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBIdxInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;


end;

procedure TACBIdxFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBIdxInfoMgr.ReadDocDat(ID);
end;

procedure TACBIdxFrm.SetInit(Parent: TWinControl;Const FileName:String);
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

    ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('日期');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('余额(万元)');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');    

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBIdxFrm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin

    FLockMemoChange := True;
Try

   ListValue.ClearNodes;

   For i:=0 to High(ACBIdxInfoMgr.ACBIdxInfo.HolderLst) do
   Begin
     AItem :=  ListValue.Add;
     With  ACBIdxInfoMgr.ACBIdxInfo Do
     Begin
       AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
       AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FormatDateTime('yyyy-mm-dd',HolderLst[i].ADate);
       AItem.Strings[ListValue.ColumnByName('Column_A2').Index] := FloatToStr(HolderLst[i].Value);
     End;
   End;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBIdxFrm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  AIdxInfo  : TACBIdxInfo;
  BaseDate : TDate;
  Str : String;
begin
Try

   AIdxInfo  := ACBIdxInfoMgr.ACBIdxInfo;

   SetLength(AIdxInfo.HolderLst,ListValue.Count);

   For i:=0 to High(AIdxInfo.HolderLst) do
   Begin
     AItem :=  ListValue.Items[i];

     BaseDate := -1;
     Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A1').Index]);
     if Length(Str)>0 Then
     Begin
        if Not IsDate(Str) Then
          Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
        BaseDate := StrToDate2(Str);
     End;

     Str := AItem.Strings[ListValue.ColumnByName('Column_A2').Index];
     if Length(Str)=0 Then
        Str := '0';

     Str := ReplaceNumString(Str);
     if not isInteger(PChar(Str)) Then
         Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));

     With  AIdxInfo Do
     Begin
        HolderLst[i].ADate := BaseDate;
        HolderLst[i].Value := StrToFloat(Str);
     End;
   End;

    ACBIdxInfoMgr.ACBIdxInfo := AIdxInfo;

    FHaveChangeData := False;

Finally
End;

end;

function TACBIdxFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ACBIdxInfoMgr) Then
     Result := ACBIdxInfoMgr.GetMemoText;  
  ShowLoadDocData;

end;

{ TCBIdxInfoMgr }

constructor TCBIdxInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBIdxInfoMgr.CreateAID(var ID: String): Boolean;
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

function TCBIdxInfoMgr.DateStrToDate(Str: String): TDate;
begin
    Result := -1;
    if Length(Str)<8 Then
      Exit;
    Str := Copy(Str,1,4)+'-'+Copy(Str,5,2)+'-'+Copy(Str,7,2);
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
    Result := StrToDate2(Str);
end;

function TCBIdxInfoMgr.DelAID: Boolean;
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

destructor TCBIdxInfoMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBIdxInfoMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBIdxInfoMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBIdxInfoMgr.GetMemoText: String;
begin
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

procedure TCBIdxInfoMgr.Init;
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


procedure TCBIdxInfoMgr.ReadDocDat(const ID: String);
Var
  f : TIniFile;
  Str : String;
  StrLst:_CStrLst2;
  Count,i : integer;

Begin

  SaveDocDat;

  SetLength(StrLst,0);


  f := TIniFile.Create(FFileName);

  FNowID := ID;

  Try
  Try

  Count := f.ReadInteger(ID,'Count',0);

  if Count=0 Then
  Begin
    SetLength(FACBIdxInfo.HolderLst,Count);
    i := 0;
    While True Do
    Begin
       Str := f.ReadString(ID,'GGR'+IntToStr(i+1),'');
       if Length(Str)=0 Then
         Break;
       StrLst := DoStrArray2(Str,',');
       if High(StrLst)=1 Then
       Begin
         Count := High(FACBIdxInfo.HolderLst)+1;
         SetLength(FACBIdxInfo.HolderLst,Count+1);
         FACBIdxInfo.HolderLst[Count].ADate := DateStrToDate(StrLst[0]);
         FACBIdxInfo.HolderLst[Count].Value := StrToFloat(StrLst[1]);
       End;
       inc(i);
    End;
  End Else
  Begin
    SetLength(FACBIdxInfo.HolderLst,Count);
    For i:=0 to High(FACBIdxInfo.HolderLst) Do
    Begin
       Str := f.ReadString(ID,'GGR'+IntToStr(i+1),'');
       StrLst := DoStrArray2(Str,',');
       if High(StrLst)=1 Then
       Begin
         FACBIdxInfo.HolderLst[i].ADate := DateStrToDate(StrLst[0]);
         FACBIdxInfo.HolderLst[i].Value := StrToFloat(StrLst[1]);
       End;
    End;
  End;

  Except
  End;
  Finally
     f.Free;
  End;





end;

procedure TCBIdxInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBIdxInfoMgr.SaveDocDat;
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
  For i:=0 to High(FACBIdxInfo.HolderLst) Do
  Begin
      if FACBIdxInfo.HolderLst[i].ADate>0 Then
      Begin
        Str := Format('%s,%s',
               [formatDateTime('yyyymmdd',FACBIdxInfo.HolderLst[i].ADate),
                FloatToStr(FACBIdxInfo.HolderLst[i].Value)]);
        f.WriteString(FNowID,'GGR'+IntToStr(c+1),Str);
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


procedure TACBIdxFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBIdxFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBIdxFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TCBIdxInfoMgr.SetACBIdxInfo(
  const Value: TACBIdxInfo);
begin
  FACBIdxInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBIdxFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  ListValue.FocusedColumn<>0;
end;

procedure TACBIdxFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBIdxFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBIdxFrm.DeleteAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;
    if Not Assigned(AItem) Then
       Exit;

   AItem.Free;

   ResetNum;

end;

procedure TACBIdxFrm.InsertAData;
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

procedure TACBIdxFrm.MoveDwn;
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

procedure TACBIdxFrm.MoveUp;
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

procedure TACBIdxFrm.ResetNum;
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

procedure TACBIdxFrm.Refresh(const FileName: String);
begin
   ACBIdxInfoMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBIdxFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBIdxFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBIdxFrm.Btn_DeleteClick(Sender: TObject);
begin
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  Begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
    DeleteAData;
    SaveDocData;
  End;
end;

procedure TACBIdxFrm.Btn_InsertClick(Sender: TObject);
begin
   InsertAData;
end;

procedure TACBIdxFrm.Btn_MoveUpClick(Sender: TObject);
begin
 MoveUp;
 WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
 SaveDocData;
end;

procedure TACBIdxFrm.Btn_MoveDwnClick(Sender: TObject);
begin
  MoveDwn;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
end;


procedure TACBIdxFrm.Btn_AddClick(Sender: TObject);
begin
   ListValue.Add;
   ResetNum;
end;

procedure TACBIdxFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBIdxInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;
end;

procedure TACBIdxFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBIdxInfoMgr.DelAID() Then
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

procedure TACBIdxFrm.Txt_IDChange(Sender: TObject);
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

function TACBIdxFrm.NeedSave: Boolean;
begin
  Result := ACBIdxInfoMgr.FNeedSaveUpload;
end;

procedure TACBIdxFrm.BeSave;
begin
  ACBIdxInfoMgr.FNeedSaveUpload := False;
end;

procedure TCBIdxInfoMgr.SortInfoDate;
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp : TAIdxInfo;
  i,Count :Integer;
Begin

  if High(FACBIdxInfo.HolderLst)<0 then exit;

  i := High(FACBIdxInfo.HolderLst)+1;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin

            lTemp  := FACBIdxInfo.HolderLst[lLoop1];
            lHold  := lLoop1;
            while FACBIdxInfo.HolderLst[lHold - lHValue].ADate > lTemp.ADate do
            Begin
                 FACBIdxInfo.HolderLst[lHold] := FACBIdxInfo.HolderLst[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            FACBIdxInfo.HolderLst[lHold] := lTemp;
        End;
  Until lHValue = 0;
end;

procedure TACBIdxFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData := True;
end;

function TCBIdxInfoMgr.UpdateAID(var ID: String): Boolean;
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

procedure TACBIdxFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBIdxInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

procedure TACBIdxFrm.RefID;
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
