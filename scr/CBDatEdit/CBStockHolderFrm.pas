//****************************************************************************
//Doc4.2.0-N004-sun-090610  修改：界面截止日期的显示与日期列表同步
//****************************************************************************
unit CBStockHolderFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,IniFiles,TCommon, dxTL, dxCntner,
  TCBDatEditUnit,TDocMgr;

type


  TAStockHolder=Record
    Value : Array[0..1] of ShortString;
  End;

  TADateStockHolder=Record
    ADate : TDate;
    Info1 : TDate;
    HolderValue : Array of TAStockHolder;
  End;

  TACBStockHolder=Record
     HolderLst : Array of TADateStockHolder;
  End;

  TCBStockHolderMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FACBStockHolder: TACBStockHolder;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    FFileTxtList: TstringList;
    FFileModifyTime:Integer;
    procedure Init();
    procedure SortHolderDate();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetACBStockHolder(const Value: TACBStockHolder);
    Function GetDateSection(ID:String;ADate:TDate):String;
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    Function CreateAID(Var ID:String):Boolean;
    Function CreateADate(Var ADate:TDate):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    Function DelADate(ADate:TDate):Boolean;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    procedure Reback(Const FileName:String);
    Function GetMemoText():String;
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ACBStockHolder : TACBStockHolder read FACBStockHolder write SetACBStockHolder;
  End;

  TACBStockHolderFrm = class(TFrame)

    Panel_Left: TPanel;
    Panel_Right: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel4: TPanel;
    Panel2: TPanel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Bevel5: TBevel;
    Panel_NowID: TPanel;
    Btn_Refresh: TSpeedButton;
    Btn_Delete: TSpeedButton;
    Btn_Insert: TSpeedButton;
    Btn_MoveUp: TSpeedButton;
    Btn_MoveDwn: TSpeedButton;
    Btn_Add: TSpeedButton;
    List_Date: TListBox;
    Bevel1: TBevel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel5: TPanel;
    ListValue: TdxTreeList;
    Column_Num: TdxTreeListColumn;
    Column_A1: TdxTreeListColumn;
    Column_A3: TdxTreeListColumn;
    Panel3: TPanel;
    Txt_Info: TEdit;
    Splitter2: TSplitter;
    SpeedButton1: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Panel_Memo: TPanel;
    procedure Cbo_SectionChange(Sender: TObject);
    procedure Txt_MemoChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);
    procedure ListValueEditing(Sender: TObject; Node: TdxTreeListNode;
      var Allow: Boolean);
    procedure ListValueEdited(Sender: TObject; Node: TdxTreeListNode);
    procedure Btn_RefreshClick(Sender: TObject);
    procedure Btn_InsertClick(Sender: TObject);
    procedure Btn_MoveUpClick(Sender: TObject);
    procedure Btn_MoveDwnClick(Sender: TObject);
    procedure ListValueCustomDrawCell(Sender: TObject; ACanvas: TCanvas;
      ARect: TRect; ANode: TdxTreeListNode; AColumn: TdxTreeListColumn;
      ASelected, AFocused, ANewItemRow: Boolean; var AText: String;
      var AColor: TColor; AFont: TFont; var AAlignment: TAlignment;
      var ADone: Boolean);
    procedure Btn_DeleteClick(Sender: TObject);
    procedure Btn_AddClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure List_DateClick(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Txt_Info3Exit(Sender: TObject);
    procedure Txt_InfoChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
  private
    { Private declarations }
    ACBStockHolderMgr : TCBStockHolderMgr;
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

    Procedure SetBtnEnabled();
    Procedure SaveDocData();
    Procedure LoadDocData();
    Procedure ShowLoadDocDate();
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

procedure TACBStockHolderFrm.Init(Const FileName:String);
Var
  i : Integer;
  AItem : TdxTreeListNode;
begin

   FLockMemoChange := True;


   Txt_Info.Text :=  '';

   ListValue.ClearNodes;

   For i:=1 to 10 do
   Begin
     AItem :=  ListValue.Add;
     AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i);
   End;


   if Not Assigned(ACBStockHolderMgr) Then
      ACBStockHolderMgr := TCBStockHolderMgr.Create(FileName);

   BeSave;

   List_ID.Clear;
   For i:=0 to ACBStockHolderMgr.IDCount-1 do
       List_ID.Items.Add(ACBStockHolderMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocDate;
   End;

end;

procedure TACBStockHolderFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBStockHolderMgr.ReadDocDat(ID);
end;

procedure TACBStockHolderFrm.SetInit(Parent: TWinControl;Const FileName:String);
begin


    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton5.Caption := FAppParam.ConvertString('删除');
    SpeedButton6.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');
    Panel3.Caption := FAppParam.ConvertString('截止2004年6月30日。');

    SpeedButton4.Caption  := FAppParam.ConvertString('>>删除日期');
    SpeedButton3.Caption  := FAppParam.ConvertString('>>新增日期');
    Btn_Refresh.Caption  := FAppParam.ConvertString('>>刷新');
    Btn_Delete.Caption  := FAppParam.ConvertString('>>删除');
    Btn_Insert.Caption  := FAppParam.ConvertString('>>插入');
    Btn_Add.Caption  := FAppParam.ConvertString('>>新增');
    Btn_MoveUp.Caption  := FAppParam.ConvertString('>>上移');
    Btn_MoveDwn.Caption  := FAppParam.ConvertString('>>下移');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');


    ListValue.Columns[0].Caption := FAppParam.ConvertString('名次');
    ListValue.Columns[1].Caption := FAppParam.ConvertString('债券持有人名称');
    ListValue.Columns[2].Caption := FAppParam.ConvertString('持有量(张)');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBStockHolderFrm.ShowLoadDocData;
Var
  Index,i : Integer;
  AItem : TdxTreeListNode;
begin
    FLockMemoChange := True;
Try
   ListValue.ClearNodes;
   SetBtnEnabled;
   if List_Date.ItemIndex<0 Then Exit;
   Index := List_Date.ItemIndex;

   //=====Doc4.2.0-N004-sun-090610 =============================================
   //获取选中的List_Date的行号
   if  Txt_Info.Text <> List_Date.Items[Index] then
       Txt_Info.Text := List_Date.Items[Index];  //获取选中行的内容
   {
   With ACBStockHolderMgr.ACBStockHolder.HolderLst[Index] Do
   Begin
     Txt_Info.Text := DateToStr(Info1);
   End;
   }
  //============================================================================
  try
     if Length(ACBStockHolderMgr.ACBStockHolder.HolderLst)>0 then
     For i:=0 to High(ACBStockHolderMgr.ACBStockHolder.HolderLst[Index].HolderValue) do
     Begin
       AItem :=  ListValue.Add;
       With  ACBStockHolderMgr.ACBStockHolder.HolderLst[Index].HolderValue[i] Do
       Begin
         AItem.Strings[ListValue.ColumnByName('Column_Num').Index] := IntToStr(i+1);
         AItem.Strings[ListValue.ColumnByName('Column_A1').Index] := Value[0];
         AItem.Strings[ListValue.ColumnByName('Column_A3').Index] := Value[1];
       End;
     End;
  except
     on e:Exception do
       e:= nil;
  end;

Finally
   FLockMemoChange := false;
End;

end;

procedure TACBStockHolderFrm.SaveDocData;
Var
  Index,i : Integer;
  AItem : TdxTreeListNode;
  AStockHolder  : TACBStockHolder;
  Str : String;
begin
Try

   if List_Date.ItemIndex<0 Then Exit;

   Index := List_Date.ItemIndex;

   AStockHolder  := ACBStockHolderMgr.ACBStockHolder;

    Str := Txt_Info.Text;
    if Not IsDate(Str) Then
      Raise Exception.Create(FAppParam.ConvertString('日期输入错误'));

   AStockHolder.HolderLst[Index].Info1 := StrToDate2(Trim(Txt_Info.Text));

   SetLength(AStockHolder.HolderLst[Index].HolderValue,ListValue.Count);

   For i:=0 to ListValue.Count-1 do
   Begin
     AItem :=  ListValue.Items[i];
     With AStockHolder.HolderLst[Index].HolderValue[i] Do
     Begin

        Value[0] := AItem.Strings[ListValue.ColumnByName('Column_A1').Index];

        Str := ReplaceNumString(AItem.Strings[ListValue.ColumnByName('Column_A3').Index]);
        if (Length(Str)>0) and (UpperCase(Str)<>'NA') Then
        Begin
           if Not IsInteger(PChar(Str)) Then
              Raise Exception.Create(Str+FAppParam.ConvertString(' 不是一个合法的数值.'));
        End;
        Value[1] := Str;

     End;
   End;

    ACBStockHolderMgr.ACBStockHolder := AStockHolder;
    FHaveChangeData := false;

Finally
End;

end;

function TACBStockHolderFrm.GetMemoText: String;
begin

  Result := '';

  if FHaveChangeData  Then
     SaveDocData;

  if Assigned(ACBStockHolderMgr) Then
     Result := ACBStockHolderMgr.GetMemoText;  
  ShowLoadDocDate;
end;

{ TCBStockHolderMgr }

constructor TCBStockHolderMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  FFileTxtList := TstringList.Create;
  FFileModifyTime := 0;
  Init;
end;

function TCBStockHolderMgr.CreateADate(var ADate: TDate): Boolean;
Var
  i : Integer;
begin

   Result := False;

   if Length(FNowID)=0 Then
   Begin
       ShowMessage(FAppParam.ConvertString('请先选择一代码.'));
       Exit;
   End;

   if Not NewADate(ADate) Then
      Exit;

   For i:=0 to High(FACBStockHolder.HolderLst) do
   Begin
      if FACBStockHolder.HolderLst[i].ADate=ADate Then
      Begin
         ShowMessage(FAppParam.ConvertString('日期已存在.'));
         Exit;
      End;
   End;


   i := High(FACBStockHolder.HolderLst)+1;
   SetLength(FACBStockHolder.HolderLst,i+1);
   FACBStockHolder.HolderLst[i].ADate := ADate;

   Result := True;

end;

function TCBStockHolderMgr.CreateAID(var ID: String): Boolean;
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


function TCBStockHolderMgr.DelADate(ADate: TDate): Boolean;
Var
  i,j : Integer;
  f : TIniFile;
begin

   Result := False;
   f := nil;

   if Length(FNowID)=0 Then
      Exit;

Try
Try

   For i:=0 to High(FACBStockHolder.HolderLst) do
   Begin
      if FACBStockHolder.HolderLst[i].ADate=ADate Then
      Begin
         for j:=i to High(FACBStockHolder.HolderLst)-1 do
           FACBStockHolder.HolderLst[j] := FACBStockHolder.HolderLst[j+1];
        SetLength(FACBStockHolder.HolderLst,High(FACBStockHolder.HolderLst));
        f := TIniFile.Create(FFileName);

        //刪除日期
        f.EraseSection(GetDateSection(FNowID,ADate));

        //重新保存
        f.EraseSection(FNowID);
        f.WriteInteger(FNowID,'Count', High(FACBStockHolder.HolderLst)+1);
        For j:=0 to High(FACBStockHolder.HolderLst) Do
           f.WriteString(FNowID,IntToStr(j+1),
                       FormatDateTime('yyyymmdd',FACBStockHolder.HolderLst[j].ADate));

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

function TCBStockHolderMgr.DelAID: Boolean;
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

        //刪除日期
        For j:=0 to High(FACBStockHolder.HolderLst) do
           f.EraseSection(GetDateSection(ID,FACBStockHolder.HolderLst[j].ADate));


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

destructor TCBStockHolderMgr.Destroy;
begin

  FFileMemo.Free;
  FFileTxtList.Free; 
  //inherited;
end;

function TCBStockHolderMgr.GetDateSection(ID: String;
  ADate: TDate): String;
begin
   Result := 'D'+ID+'_'+FormatDateTime('yyyymmdd',ADate);
end;

function TCBStockHolderMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBStockHolderMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBStockHolderMgr.GetMemoText: String;
begin
   SaveDocDat;
   FFileMemo.LoadFromFile(FFileName);
   FFileMemo.Text := Trim2String(FFileMemo);
   Result := FFileMemo.Text;
end;

procedure TCBStockHolderMgr.Init;
Var
  i,j : Integer;
  Str : String;
begin

try
try

   FNeedSave := false;
   FFileMemo.LoadFromFile(FFileName);
   SetLength(FIDLst,0);
   FFileMemo.Text := Trim2String(FFileMemo);

   For i:=0 to FFileMemo.Count-1 do
   Begin
       if (Pos('[D',FFileMemo.Strings[i])=0) and
          (Pos('[',FFileMemo.Strings[i])>0) and
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


procedure TCBStockHolderMgr.ReadDocDat(const ID: String);
Var
 // F:TextFile;
  Str : String;
  StrLst:_CStrLst2;
  r,a,v,HolderCount: integer;
Begin

  SaveDocDat;

  FNowID := ID;
  SetLength(FACBStockHolder.HolderLst,0);

  if Not fileExists(FFilename) then
     Exit;

try
try


  if FFileModifyTime<>FileAge(FFileName) Then
  Begin
     FFileTxtList.LoadFromFile(FFileName);
     FFileModifyTime := FileAge(FFileName);
  End;

  r := -1;
  While True Do
  Begin
      inc(r);
      if r>FFileTxtList.Count-1 Then
         Break;

      Str := FFileTxtList.Strings[r];
      if Not ((Pos('[',Str)>0) and (Pos(']',Str)>0)) Then
         Continue;
      //Seek ID
      if Str='['+FNowID+']' Then
      Begin
        //Get Date Count
        While True Do
        Begin
           inc(r);
           if r>FFileTxtList.Count-1 Then
              Break;
           Str := FFileTxtList.Strings[r];
           if Pos('Count=',Str)>0 Then
           Begin
              ReplaceSubString('Count=','',Str);
              if StrToInt(Str)=0 Then
                 Break;
              While True Do
              Begin
                 inc(r);
                 if r>FFileTxtList.Count-1 Then
                    Break;
                 Str := FFileTxtList.Strings[r];
                 if Pos('=',Str)>0 Then
                 Begin
                    Str := Copy(Str,Pos('=',Str)+1,Length(Str)-Pos('=',Str));
                    a := High(FACBStockHolder.HolderLst)+1;
                    SetLength(FACBStockHolder.HolderLst,a+1);
                    FACBStockHolder.HolderLst[a].ADate := DateStrToDate(Str);
                 End;
                 if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
                    Break;
              End;
           End;
           if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
              Break;
        End;
        //Get Date Count
        Break;
      End;
      //Seek ID
  End;


  r := -1;
  HolderCount :=  High(FACBStockHolder.HolderLst)+1;
  While True Do
  Begin
      if HolderCount=0 Then
         Break;
      inc(r);
      if r>FFileTxtList.Count-1 Then
         Break;
      Str := FFileTxtList.Strings[r];
      if Not ((Pos('[',Str)>0) and (Pos(']',Str)>0) and (Pos('D',Str)>0)) Then
         Continue;
      //Get All Date info
      For a:=0 to High(FACBStockHolder.HolderLst) Do
      Begin
          if High(FACBStockHolder.HolderLst[a].HolderValue)>=0 Then
             Continue;
          if Str='['+GetDateSection(FNowID,FACBStockHolder.HolderLst[a].ADate)+']' Then
          Begin
            dec(HolderCount);
            While True Do
            Begin
               inc(r);
               if r>FFileTxtList.Count-1 Then
                    Break;
               Str := FFileTxtList.Strings[r];
               if Pos('Count=',Str)>0 Then
                  Continue;
               if Pos('info1=',Str)>0 Then
               Begin
                    ReplaceSubString('info1=','',Str);
                    FACBStockHolder.HolderLst[a].Info1 := DateStrToDate(str);
                    Continue;
               End;
               if (Pos('=',Str)>0) and (Pos(';',Str)>0) Then
               Begin
                     Str := Copy(Str,Pos('=',Str)+1,Length(Str)-Pos('=',Str));
                     SetLength(StrLst,0);
                     StrLst := DoStrArray2(Str,';');     //资料分割
                     if High(StrLst)=1 Then
                     Begin
                            v := High(FACBStockHolder.HolderLst[a].HolderValue)+1;
                            SetLength(FACBStockHolder.HolderLst[a].HolderValue,v+1);
                            FACBStockHolder.HolderLst[a].HolderValue[v].Value[0] := StrLst[0];
                            FACBStockHolder.HolderLst[a].HolderValue[v].Value[1] := StrLst[1];
                     end;
                     Continue;
               End;
               if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
                  Break;
            End;
            if (Pos('[',Str)>0) and (Pos(']',Str)>0) Then
            Begin
               dec(r);
               Break;
            End;
          End;
      End;
      //Get All Date info
  End;

except
end;
finally
  SortHolderDate;
end;
end;


procedure TCBStockHolderMgr.Reback(Const FileName:String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBStockHolderMgr.SaveDocDat;
Var
  f : TIniFile;
  Str : String;
  i,j,k,c : integer;
  DateSection : String;
  AHolder : TAStockHolder;
Begin

  if Length(FNowID)=0 Then
    Exit;

  if Not FNeedSave Then
    Exit;

  SortHolderDate;

  f := TIniFile.Create(FFileName);

  Try
  Try

  f.EraseSection(FNowID);
  f.WriteInteger(FNowID,'Count', High(FACBStockHolder.HolderLst)+1);

  For i:=0 to High(FACBStockHolder.HolderLst) Do
  Begin

      f.WriteString(FNowID,IntToStr(i+1),
                    FormatDateTime('yyyymmdd',FACBStockHolder.HolderLst[i].ADate));

      DateSection := GetDateSection(FNowID,FACBStockHolder.HolderLst[i].ADate);

      f.EraseSection(DateSection);
      f.WriteInteger(DateSection,'Count', 0);

      f.WriteString(DateSection,'info1', FormatDateTime('yyyymmdd',FACBStockHolder.HolderLst[i].Info1));

      c := 0;
      for k:=0 to High(FACBStockHolder.HolderLst[i].HolderValue) do
      Begin


        AHolder := FACBStockHolder.HolderLst[i].HolderValue[k];
        For j:=0 to High(AHolder.Value) do
        Begin
          Str := Trim(AHolder.Value[j]);
          ReplaceSubString(';','',Str);
          AHolder.Value[j] := Str;
        End;

        if Length(AHolder.Value[0])>0 Then
        Begin
           For j:=0 to High(AHolder.Value) do
           Begin
             if Length(AHolder.Value[j])=0 Then
                AHolder.Value[j] := 'na';
           End;
           Str := Format('%s;%s',
                 [AHolder.Value[0],
                  AHolder.Value[1]]);
           f.WriteString(DateSection,IntToStr(c+1),Str);
           inc(c);
        End;
      End;
      f.WriteInteger(DateSection,'Count', c);
  End;




  Except
  End;
  Finally
     f.Free;
     FNeedSave := False;
  End;

end;


procedure TACBStockHolderFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBStockHolderFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
      SaveDocData;
end;

procedure TACBStockHolderFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocDate;
end;


procedure TCBStockHolderMgr.SetACBStockHolder(
  const Value: TACBStockHolder);
begin
  FACBStockHolder := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBStockHolderFrm.ListValueEditing(Sender: TObject;
  Node: TdxTreeListNode; var Allow: Boolean);
begin
   Allow :=  ListValue.FocusedColumn<>0;
end;

procedure TACBStockHolderFrm.ListValueEdited(Sender: TObject;
  Node: TdxTreeListNode);
begin
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
end;

procedure TACBStockHolderFrm.Btn_RefreshClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocDate;
end;

procedure TACBStockHolderFrm.InsertAData;
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

procedure TACBStockHolderFrm.Btn_InsertClick(Sender: TObject);
begin
   InsertAData;
end;

procedure TACBStockHolderFrm.MoveUp;
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

procedure TACBStockHolderFrm.ResetNum;
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

procedure TACBStockHolderFrm.Btn_MoveUpClick(Sender: TObject);
begin
 MoveUp;
 WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
 SaveDocData;
end;

procedure TACBStockHolderFrm.MoveDwn;
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

procedure TACBStockHolderFrm.Btn_MoveDwnClick(Sender: TObject);
begin
  MoveDwn;
  WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
  SaveDocData;
end;

procedure TACBStockHolderFrm.ListValueCustomDrawCell(Sender: TObject;
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

procedure TACBStockHolderFrm.DeleteAData;
Var
 AItem : TdxTreeListNode;
begin

    AItem := ListValue.FocusedNode;
    if Not Assigned(AItem) Then
       Exit;

   AItem.Free;

   ResetNum;

end;

procedure TACBStockHolderFrm.Btn_DeleteClick(Sender: TObject);
begin
  if (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
  Begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
    DeleteAData;
    SaveDocData;
  End;
end;

procedure TACBStockHolderFrm.Refresh(const FileName: String);
begin

   ACBStockHolderMgr.Reback(FileName);
   Init(FileName);

end;

procedure TACBStockHolderFrm.AddAData;
begin
   ListValue.Add;
   ResetNum;
end;

procedure TACBStockHolderFrm.Btn_AddClick(Sender: TObject);
begin
  AddAData;
end;

procedure TACBStockHolderFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBStockHolderMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocDate;
   End;

end;

procedure TACBStockHolderFrm.SpeedButton6Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBStockHolderMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

procedure TACBStockHolderFrm.Txt_IDChange(Sender: TObject);
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
          ShowLoadDocDate;
          Break;
        End;
      end;
      i:=i+1;
    End;
  end;
end;

function TACBStockHolderFrm.NeedSave: Boolean;
begin
   Result := ACBStockHolderMgr.FNeedSaveUpload;
end;

procedure TACBStockHolderFrm.BeSave;
begin
   ACBStockHolderMgr.FNeedSaveUpload := False
end;

procedure TACBStockHolderFrm.ShowLoadDocDate;
Var
  i : Integer;
begin

    FLockMemoChange := True;
Try

   List_Date.Clear;
   ListValue.ClearNodes;

   For i:=0 to High(ACBStockHolderMgr.ACBStockHolder.HolderLst) do
      List_Date.Items.Add(FormatDateTime('yyyy-mm-dd',
          ACBStockHolderMgr.ACBStockHolder.HolderLst[i].ADate));

   if List_Date.Count>0 Then
      List_Date.ItemIndex := 0;

   ShowLoadDocData;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBStockHolderFrm.List_DateClick(Sender: TObject);
begin
   ShowLoadDocData;
end;

procedure TACBStockHolderFrm.SpeedButton3Click(Sender: TObject);
Var
  ADate : TDate;
begin

   if ACBStockHolderMgr.CreateADate(ADate) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_Date.ItemIndex := List_Date.Items.Add(FormatDateTime('yyyy-mm-dd',ADate));
      ShowLoadDocData;
   End;

end;

procedure TCBStockHolderMgr.SortHolderDate;
var
  //排序用
  lLoop1,lHold,lHValue : Longint;
  lTemp : TADateStockHolder;
  i,Count :Integer;
Begin

  if High(FACBStockHolder.HolderLst)<0 then exit;

  i := High(FACBStockHolder.HolderLst)+1;
  Count   := i;
  lHValue := Count-1;
  repeat
      lHValue := 3 * lHValue + 1;
  Until lHValue > (i-1);

  repeat
        lHValue := Round(lHValue / 3);
        For lLoop1 := lHValue  To (i-1) do
        Begin

            lTemp  := FACBStockHolder.HolderLst[lLoop1];
            lHold  := lLoop1;
            while FACBStockHolder.HolderLst[lHold - lHValue].ADate < lTemp.ADate do
            Begin
                 FACBStockHolder.HolderLst[lHold] := FACBStockHolder.HolderLst[lHold - lHValue];
                 lHold := lHold - lHValue;
                 If lHold < lHValue Then break;
            End;
            FACBStockHolder.HolderLst[lHold] := lTemp;
        End;
  Until lHValue = 0;

end;

procedure TACBStockHolderFrm.SpeedButton4Click(Sender: TObject);
Var
  ADate : TDate;
  Index : Integer;
begin

Try

    if List_Date.ItemIndex<0 Then
      exit;

    if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
    Exit;

    ADate := StrToDate(List_Date.Items[List_Date.ItemIndex]);

   if ACBStockHolderMgr.DelADate(ADate) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      ListValue.ClearNodes;

      Index := List_Date.ItemIndex;
      List_Date.Items.Delete(List_Date.ItemIndex);

      if Index>List_Date.Count-1 Then
         Index := List_Date.Count-1;
      if Index>=0 Then
        List_Date.ItemIndex := Index;
      ShowLoadDocDate;
   End;

Finally
End;

end;

procedure TACBStockHolderFrm.SetBtnEnabled;
begin
   Btn_Refresh.Enabled := List_Date.ItemIndex>=0;
   Btn_Delete.Enabled := (FEditEnabled or
                          not InRightList(Btn_Delete.Caption)) and
                          (List_Date.ItemIndex>=0);
   Btn_Insert.Enabled := (FEditEnabled or
                          not InRightList(Btn_Insert.Caption)) and
                          (List_Date.ItemIndex>=0);
   Btn_Add.Enabled := (FEditEnabled or
                          not InRightList(Btn_Add.Caption)) and
                          (List_Date.ItemIndex>=0);
   Btn_MoveUp.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveUp.Caption)) and
                          (List_Date.ItemIndex>=0);
   Btn_MoveDwn.Enabled := (FEditEnabled or
                          not InRightList(Btn_MoveDwn.Caption)) and
                          (List_Date.ItemIndex>=0);
end;

procedure TACBStockHolderFrm.Txt_Info3Exit(Sender: TObject);
begin
  if FHaveChangeData Then
  begin
     WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
     SaveDocData;
  end;
end;

procedure TACBStockHolderFrm.Txt_InfoChange(Sender: TObject);
begin
  if Not FLockMemoChange Then
     FHaveChangeData := True;
end;

function TCBStockHolderMgr.UpdateAID(var ID: String): Boolean;
Var
 i,j : Integer;
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
        //刪除日期
        For j:=0 to High(FACBStockHolder.HolderLst) do
           f.EraseSection(GetDateSection(FNowID,FACBStockHolder.HolderLst[j].ADate));
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

procedure TACBStockHolderFrm.SpeedButton5Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

    if List_ID.ItemIndex<0 Then
      exit;

    if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
    Exit;

   if ACBStockHolderMgr.DelAID() Then
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
        ShowLoadDocDate;
      End;

   End;
Finally
End;

end;

procedure TACBStockHolderFrm.RefID;
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
