unit CBDateTwFrm;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxTL, dxCntner, Buttons, StdCtrls, ExtCtrls,TDocMgr,csDef,
  TCBDatEditUnit,inifiles,TCommon;

type

  TACBDateInfo=Record
     nifadate : TDate;
     songjiandate : TDate;
     hezhundate :TDate;
     faxingdate : TDate;
     shangguidate : TDate;
     xiaguidate : TDate;
  End;

  TCBDateInfoMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBDateInfo: TACBDateInfo;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init(FFileName : String);
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBDateInfo(const Value: TACBDateInfo);
    Function DateStrToDate(Str:String):TDate;
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    procedure Reback(Const FileName:String);
    Function GetMemoText():String;
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBDateInfo : TACBDateInfo read FACBDateInfo write SetACBDateInfo;
  End;

  TACBDateTwFrm = class(TFrame)
    Splitter1: TSplitter;
    Bevel2: TBevel;
    Panel_Left: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Txt_ID: TEdit;
    Panel4: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    Panel_Right: TPanel;
    Panel2: TPanel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Bevel5: TBevel;
    Btn_Refresh: TSpeedButton;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A2: TdxTreeListColumn;
    Panel_NowID: TPanel;
    procedure ListValueEditChange(Sender: TObject);
    procedure ListValueEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure List_IDClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure Btn_RefreshClick(Sender: TObject);
  private
    { Private declarations }
    ACBDateInfoMgr  : TCBDateInfoMgr;
    FLockMemoChange : Boolean;
    FHaveChangeData : Boolean;
    procedure Init(Const FileName:String);
    Procedure CreateDefauleItem();
  public
    { Public declarations }
     procedure RefID();
     Procedure Refresh(Const FileName:String);
     Procedure SetInit(Parent:TWinControl;Const FileName:String);
     Procedure BeSave();
     Procedure LoadDocData();
     Procedure ShowLoadDocData();
     Procedure SaveDocData();
     Function GetMemoText():String;

  end;

implementation

{$R *.dfm}

{ TCBDateInfoMgr }

constructor TCBDateInfoMgr.Create(const FileName: String);
begin
  FFileName := FileName;
 // FFileMemo := TStringList.Create;
  Init(FFileName);
end;

function TCBDateInfoMgr.CreateAID(var ID: String): Boolean;
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

  // ReadDocDat(ID);

   Result := True;


end;


function TCBDateInfoMgr.DateStrToDate(Str: String): TDate;
begin
  Result := -1;
    if Length(Str)<8 Then
      Exit;
    Str := Copy(Str,1,4)+'-'+Copy(Str,5,2)+'-'+Copy(Str,7,2);
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
    Result := StrToDate2(Str);
end;

function TCBDateInfoMgr.DelAID: Boolean;
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

destructor TCBDateInfoMgr.Destroy;
begin

  inherited;
end;

function TCBDateInfoMgr.GetID(Index: Integer): String;
begin
  Result := FIDLst[Index];
end;

function TCBDateInfoMgr.GetIDCount: Integer;
begin
  Result := High(FIDLst)+1;
end;

function TCBDateInfoMgr.GetMemoText: String;
begin
   FFileMemo := TStringList.Create ;
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

procedure TCBDateInfoMgr.Init(FFileName: String);
Var
  i,j : Integer;
  Str : String;
  FFileMemo: TStringList;
begin
  FFileMemo := TStringList.Create ;
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

procedure TCBDateInfoMgr.ReadDocDat(const ID: String);
Var
  f : TIniFile;
Begin

  SaveDocDat;
  f := TIniFile.Create(FFileName);
  FNowID := ID;

  Try
  Try
      With FACBDateInfo Do
      Begin
        nifadate := DateStrToDate(f.ReadString(ID,'nifadatetw',''));
        songjiandate := DateStrToDate(f.ReadString(ID,'songjiandate',''));
        hezhundate := DateStrToDate(f.ReadString(ID,'hezhundate',''));
        faxingdate:= DateStrToDate(f.ReadString(ID,'faxingdate',''));
        shangguidate := DateStrToDate(f.ReadString(ID,'shangguidate',''));
        xiaguidate := DateStrToDate(f.ReadString(ID,'xiaguidate',''));
      End;

  Except
  End;
  Finally
     f.Free;
  End;

end;

procedure TCBDateInfoMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init(FFileName);
end;

procedure TCBDateInfoMgr.SaveDocDat;
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
  With  FACBDateInfo do
  Begin
      if nifadate>0 Then
        f.WriteString(FNowID,'nifadatetw',formatDateTime('yyyymmdd',nifadate));
      if songjiandate>0 Then
        f.WriteString(FNowID,'songjiandate',formatDateTime('yyyymmdd',songjiandate));
      if hezhundate>0 Then
        f.WriteString(FNowID,'hezhundate',formatDateTime('yyyymmdd',hezhundate));
      if faxingdate>0 Then
        f.WriteString(FNowID,'faxingdate',formatDateTime('yyyymmdd',faxingdate));
      if shangguidate>0 Then
        f.WriteString(FNowID,'shangguidate',formatDateTime('yyyymmdd',shangguidate));
      if xiaguidate>0 Then
        f.WriteString(FNowID,'xiaguidate',formatDateTime('yyyymmdd',xiaguidate));
  End;

  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;
end;


procedure TCBDateInfoMgr.SetACBDateInfo(const Value: TACBDateInfo);
begin
  FACBDateInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

function TCBDateInfoMgr.UpdateAID(var ID: String): Boolean;
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

{ TACBDateTwFrm }

procedure TACBDateTwFrm.BeSave;
begin
   ACBDateInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBDateTwFrm.CreateDefauleItem;
Var
  AItem : TdxTreeListNode;
begin
   ListValue.ClearNodes;

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(1);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('拟发日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(2);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('送件日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(3);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('核准日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(4);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('发行日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(5);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('上柜日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(6);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('下柜日期');

end;

procedure TACBDateTwFrm.Init(const FileName: String);
Var
  i : Integer;
begin

   FLockMemoChange := True;

   CreateDefauleItem;


   if Not Assigned(ACBDateInfoMgr) Then
      ACBDateInfoMgr := TCBDateInfoMgr.Create(FileName);
      
   BeSave;

   List_ID.Clear;
   For i:=0 to ACBDateInfoMgr.IDCount-1 do
       List_ID.Items.Add(ACBDateInfoMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex :=GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBDateTwFrm.LoadDocData;
Var
  ID : String;
  i : Integer;
  AItem : TdxTreeListNode;
  BaseDate : TDate;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBDateInfoMgr.ReadDocDat(ID);
  FLockMemoChange := True;
Try

   ListValue.ClearNodes;

   CreateDefauleItem;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     BaseDate := 0;
     With  ACBDateInfoMgr.ACBDateInfo Do
     Begin
       Case i of
            0: BaseDate := nifadate;
            1: BaseDate := songjiandate;
            2: BaseDate := hezhundate;
            3: BaseDate := faxingdate;
            4: BaseDate := shangguidate;
            5: BaseDate := xiaguidate;
       End;
       if BaseDate>0 Then
          AItem.Strings[ListValue.ColumnByName('Column_A2').Index] :=DateToStr(BaseDate);
     End;
   End;

Finally
   FLockMemoChange := false;
End;
end;

procedure TACBDateTwFrm.RefID;
begin

  try
    if List_ID.Count>0 Then
     Begin
        List_ID.ItemIndex := GetItemIndex(List_ID);
        LoadDocData;
       // ShowLoadDocData;
     End;
  except
  end;

end;

procedure TACBDateTwFrm.Refresh(const FileName: String);
begin
  ACBDateInfoMgr.Reback(FileName);
  Init(FileName);
end;

procedure TACBDateTwFrm.SaveDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  ADateInfo  : TACBDateInfo;
  Str : String;
  BaseDate : TDate;
begin

Try

   ADateInfo  := ACBDateInfoMgr.ACBDateInfo;

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With  ADateInfo Do
     Begin

         BaseDate := -1;
         Str := Trim(AItem.Strings[ListValue.ColumnByName('Column_A2').Index]);
         if Length(Str)>0 Then
         Begin
           if Not IsDate(Str) Then
               Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));
           BaseDate := StrToDate2(Str);
         End;
         Case i of
            0: nifadate := BaseDate;
            1: songjiandate := BaseDate;
            2: hezhundate := BaseDate;
            3: faxingdate := BaseDate;
            4: shangguidate := BaseDate;
            5: xiaguidate := BaseDate;
        End;
     End;
   End;

    ACBDateInfoMgr.ACBDateInfo := ADateInfo;

    FHaveChangeData := False;


Finally
End;

end;

procedure TACBDateTwFrm.SetInit(Parent: TWinControl;
  const FileName: String);
begin
  Panel1.Caption := FAppParam.ConvertString('搜寻代码');
  SpeedButton1.Caption := FAppParam.ConvertString('新增');
  SpeedButton2.Caption := FAppParam.ConvertString('删除');
  SpeedButton3.Caption := FAppParam.ConvertString('修改');
  Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
  Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');

  Panel_Memo.Caption := FAppParam.ConvertString('请输入Key值或转债代码');

  ListValue.Columns[0].Caption := FAppParam.ConvertString('序号');
  ListValue.Columns[1].Caption := FAppParam.ConvertString('标题');
  ListValue.Columns[2].Caption := FAppParam.ConvertString('内容');

  Self.Parent := Parent;
  Self.Align := alClient;

  Init(FileName);
end;

procedure TACBDateTwFrm.ShowLoadDocData;
begin

end;

procedure TACBDateTwFrm.ListValueEditChange(Sender: TObject);
begin
   FHaveChangeData := True;
end;

procedure TACBDateTwFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBDateTwFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
  Allow :=  (ListValue.FocusedColumn<>0) and
             (ListValue.FocusedColumn<>1) ;
end;

procedure TACBDateTwFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBDateTwFrm.List_IDClick(Sender: TObject);
begin
 LoadDocData;
end;

procedure TACBDateTwFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBDateInfoMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBDateTwFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBDateInfoMgr.DelAID() Then
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
      End;

   End;
Finally
End;

end;

procedure TACBDateTwFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;
      
   if ACBDateInfoMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;



function TACBDateTwFrm.GetMemoText: String;
begin
  if FHaveChangeData Then
     SaveDocData;

  Result := '';
  if Assigned(ACBDateInfoMgr) Then
     Result := ACBDateInfoMgr.GetMemoText;
end;

procedure TACBDateTwFrm.Txt_IDChange(Sender: TObject);
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

procedure TACBDateTwFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
end;

end.
