unit CBDateFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr;

type

  TACBDateInfo=Record
     nifadate : TDate;
     guohuidate : TDate;
     faxing : TDate;
     shengoudate : TDate;
     dongjiestartdate: TDate;
     dongjieenddate:TDate;
     shangshidate : TDate;
     //interestdate:TDate;
     //strikedate : TDate
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
    procedure Init();
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
    Function GetMemoText():String;
    procedure Reback(Const FileName:String);
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBDateInfo : TACBDateInfo read FACBDateInfo write SetACBDateInfo;
  End;

  TACBDateFrm = class(TFrame)
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
    Btn_Refresh: TSpeedButton;
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
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure ListValueEditChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    ACBDateInfoMgr  : TCBDateInfoMgr;
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

procedure TACBDateFrm.Init(Const FileName:String);
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

procedure TACBDateFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBDateInfoMgr.ReadDocDat(ID);
end;

procedure TACBDateFrm.SetInit(Parent: TWinControl;Const FileName:String);
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

procedure TACBDateFrm.ShowLoadDocData;
Var
  i : Integer;
  AItem : TdxTreeListNode;
  BaseDate : TDate;
begin

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
            1: BaseDate := guohuidate;
            //3: BaseDate := gonggaodate;
            2: BaseDate := faxing;
            3: BaseDate := shengoudate;
            4: BaseDate := dongjiestartdate;
            5: BaseDate := dongjieenddate;
            6: BaseDate := shangshidate;
            //7: BaseDate := interestdate;
            //8: BaseDate := strikedate;
       End;
       if BaseDate>0 Then
          AItem.Strings[ListValue.ColumnByName('Column_A2').Index] :=DateToStr(BaseDate);
     End;
   End;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBDateFrm.SaveDocData;
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
            1: guohuidate := BaseDate;
            //3: gonggaodate := BaseDate;
            2: faxing := BaseDate;
            3: shengoudate := BaseDate;
            4: dongjiestartdate := BaseDate;
            5: dongjieenddate := BaseDate;
            6: shangshidate := BaseDate;
            //7: interestdate := BaseDate;
            //8: strikedate := BaseDate;
        End;
     End;
   End;

    ACBDateInfoMgr.ACBDateInfo := ADateInfo;

    FHaveChangeData := False;


Finally
End;

end;

function TACBDateFrm.GetMemoText: String;
begin

  if FHaveChangeData Then
     SaveDocData;
     
  Result := '';
  if Assigned(ACBDateInfoMgr) Then
     Result := ACBDateInfoMgr.GetMemoText;  

end;

{ TCBDateInfoMgr }

constructor TCBDateInfoMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
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

   ReadDocDat(ID);

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

  FFileMemo.Free;
  //inherited;
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
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text; 
end;

procedure TCBDateInfoMgr.Init;
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
        nifadate := DateStrToDate(f.ReadString(ID,'nifadate',''));
        guohuidate := DateStrToDate(f.ReadString(ID,'guohuidate',''));
        shangshidate := DateStrToDate(f.ReadString(ID,'shangshidate',''));
        faxing := DateStrToDate(f.ReadString(ID,'faxing',''));
        shengoudate := DateStrToDate(f.ReadString(ID,'shengoudate',''));
        dongjiestartdate := DateStrToDate(f.ReadString(ID,'dongjiestartdate',''));
        dongjieenddate:= DateStrToDate(f.ReadString(ID,'dongjieenddate',''));
        //interestdate := DateStrToDate(f.ReadString(ID,'interestdate',''));
        //strikedate := DateStrToDate(f.ReadString(ID,'strikedate',''));
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
  Init;
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
        f.WriteString(FNowID,'nifadate',formatDateTime('yyyymmdd',nifadate));
      if guohuidate>0 Then
        f.WriteString(FNowID,'guohuidate',formatDateTime('yyyymmdd',guohuidate));
      if shangshidate>0 Then
        f.WriteString(FNowID,'shangshidate',formatDateTime('yyyymmdd',shangshidate));
      //if gonggaodate>0 Then
      //  f.WriteString(FNowID,'gonggaodate',formatDateTime('yyyymmdd',gonggaodate));
      if faxing>0 Then
        f.WriteString(FNowID,'faxing',formatDateTime('yyyymmdd',faxing));
      if shengoudate>0 Then
        f.WriteString(FNowID,'shengoudate',formatDateTime('yyyymmdd',shengoudate));
      if dongjiestartdate>0 Then
        f.WriteString(FNowID,'dongjiestartdate',formatDateTime('yyyymmdd',dongjiestartdate));
      if dongjieenddate>0 Then
        f.WriteString(FNowID,'dongjieenddate',formatDateTime('yyyymmdd',dongjieenddate));
      {if interestdate>0 Then
        f.WriteString(FNowID,'interestdate',formatDateTime('yyyymmdd',interestdate));
      if strikedate>0 Then
        f.WriteString(FNowID,'strikedate',formatDateTime('yyyymmdd',strikedate));
      }
  End;

  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;
end;


procedure TACBDateFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBDateFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBDateFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;


procedure TCBDateInfoMgr.SetACBDateInfo(
  const Value: TACBDateInfo);
begin
  FACBDateInfo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBDateFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  (ListValue.FocusedColumn<>0) and
             (ListValue.FocusedColumn<>1) ;
end;

procedure TACBDateFrm.Txt_InfoChange(Sender: TObject);
begin
 if Not FLockMemoChange Then
   SaveDocData;
end;

procedure TACBDateFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBDateFrm.CreateDefauleItem;
Var
  AItem : TdxTreeListNode;
begin
   ListValue.ClearNodes;

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(1);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('拟发日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(2);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('过会日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(3);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('发行日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(4);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('申购日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(5);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('资金冻结起始日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(6);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('资金冻结结束日期');

   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(7);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('上市日期');

   {
   AItem :=  ListValue.Add;
   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(8);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('付息日期');
   AItem :=  ListValue.Add;

   AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(9);
   AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := FAppParam.ConvertString('转股日期');
   }
end;

procedure TACBDateFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBDateFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBDateFrm.Refresh(const FileName: String);
begin
   ACBDateInfoMgr.Reback(FileName);
   Init(FileName);
end;


procedure TACBDateFrm.SpeedButton1Click(Sender: TObject);
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

procedure TACBDateFrm.SpeedButton2Click(Sender: TObject);
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
        ShowLoadDocData;
      End;

   End;
Finally
End;

end;

procedure TACBDateFrm.Txt_IDChange(Sender: TObject);
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

function TACBDateFrm.NeedSave: Boolean;
begin
   Result := ACBDateInfoMgr.FNeedSaveUpload;
end;

procedure TACBDateFrm.BeSave;
begin
   ACBDateInfoMgr.FNeedSaveUpload := False;
end;

procedure TACBDateFrm.ListValueEditChange(Sender: TObject);
begin
  FHaveChangeData := True;
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

procedure TACBDateFrm.SpeedButton3Click(Sender: TObject);
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

procedure TACBDateFrm.RefID;
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
