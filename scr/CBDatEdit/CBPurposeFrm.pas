unit CBPurposeFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,TCBDatEditUnit,TDocMgr
  ,TCommon;

type

  TCBPurposeMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FFileMemo:TStringList;
    FMemo: String;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetMemo(const Value: String);

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
    Property Memo:String read FMemo write SetMemo;
  End;

  TACBPurposeFrm = class(TFrame)
    Panel_Left: TPanel;
    Panel_Right: TPanel;
    Txt_Memo: TMemo;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel_NowID: TPanel;
    Panel4: TPanel;
    SpeedButton3: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Panel_Memo: TPanel;
    procedure Cbo_SectionChange(Sender: TObject);
    procedure Txt_MemoChange(Sender: TObject);
    procedure List_IDClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Txt_IDChange(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);

  private
    { Private declarations }
    ACBPurposeMgr : TCBPurposeMgr;
    FLockMemoChange : Boolean;
    procedure Init(Const FileName:String);

 //   Function ChangeFont(TextStr:String):String;
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

procedure TACBPurposeFrm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;


   Txt_ID.Text := '';
   Txt_Memo.Text := '';


    if Not Assigned(ACBPurposeMgr) Then
       ACBPurposeMgr := TCBPurposeMgr.Create(FileName);

   BeSave;

   List_ID.Clear;
   For i:=0 to ACBPurposeMgr.IDCount-1 do
       List_ID.Items.Add(ACBPurposeMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;
   
end;

procedure TACBPurposeFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBPurposeMgr.ReadDocDat(ID);
end;

procedure TACBPurposeFrm.SetInit(Parent: TWinControl;Const FileName:String);
begin


    Panel1.Caption := FAppParam.ConvertString('搜寻代码');
    SpeedButton1.Caption := FAppParam.ConvertString('新增');
    SpeedButton2.Caption := FAppParam.ConvertString('删除');
    SpeedButton3.Caption := FAppParam.ConvertString('修改');
    Panel_NowID.Caption  := FAppParam.ConvertString('目前正在编辑代码:');

    Panel_Memo.Caption := FAppParam.ConvertString('请输入转债代码');

    Self.Parent := Parent;
    Self.Align := alClient;

    Init(FileName);


end;

procedure TACBPurposeFrm.ShowLoadDocData;
begin

    FLockMemoChange := True;
Try

      Txt_Memo.Text := ACBPurposeMgr.Memo;


Finally
   FLockMemoChange := false;
End;

end;

procedure TACBPurposeFrm.SaveDocData;
begin
      ACBPurposeMgr.Memo := Txt_Memo.Text;
end;

function TACBPurposeFrm.GetMemoText: String;
begin

  Result := '';
  if Assigned(ACBPurposeMgr) Then
     Result := ACBPurposeMgr.GetMemoText;

end;

{ TCBPurposeMgr }

constructor TCBPurposeMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBPurposeMgr.CreateAID(var ID: String): Boolean;
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

   FFileMemo.Add('<ID='+ID+'>');
   FFileMemo.Add('</ID>');

   ReadDocDat(ID);

   Result := True;

end;

function TCBPurposeMgr.DelAID: Boolean;
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

procedure TCBPurposeMgr.DelDocDat;
Procedure DelSection(Var StratIndex: Integer;
f: TStringList; const Section: String);
Var
     i : integer;
     s,ts : String;
Begin

         ts := '';
         For i:=StratIndex to f.Count-1 do
         Begin
            s := f.Strings[StratIndex];
            f.Delete(StratIndex);
            if Pos(Section,UpperCase(S))>0 Then
               Break;
         End;
         StratIndex := StratIndex+1;

end;
Var
  s : String;
  i :  integer;
Begin

Try
Try

    if Length(FNowID)=0 Then
       exit;

    i := -1;

    While True do
    Begin

      Inc(i);

      If i>=FFileMemo.Count Then Break;

      S := FFileMemo.Strings[i];

      if Pos('<',s)=0 Then
         Continue;

      if Pos(UpperCase('<ID='+FNowID+'>'),UpperCase(S))>0 Then
      Begin
           DelSection(i,FFileMemo,'</ID>');
           Break;
      End;

    End;


Except
end;

Finally
End;

end;

destructor TCBPurposeMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBPurposeMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBPurposeMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBPurposeMgr.GetMemoText: String;
begin
    SaveDocDat;
    FFileMemo.Text := Trim2String(FFileMemo);
    Result := FFileMemo.Text;
end;

procedure TCBPurposeMgr.Init;
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
       if Pos('<ID=',FFileMemo.Strings[i])>0 Then
       Begin
           Str := Trim(FFileMemo.Strings[i]);
           ReplaceSubString('<ID=','',Str);
           ReplaceSubString('>','',Str);
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


procedure TCBPurposeMgr.ReadDocDat(const ID: String);
Function GetSection(Var StratIndex: Integer;
const f: TStringList; const Section: String): String;
Var
     i : integer;
     s,ts : String;
Begin
         ts := '';
         For i:=StratIndex+1 to f.Count-1 do
         Begin
                s := f.Strings[i];
                if Pos(Section,UpperCase(S))>0 Then
                Begin
                   StratIndex := i;
                   Break;
                End;
                if Length(ts)>0 Then
                   ts := ts + #13#10;
                ts := ts + s ;
         End;
         Result := ts;

end;
Var
  s : String;
  FileStr : TStringList;
  i :  integer;
Begin

Try
Try

  SaveDocDat;

  FMemo := '';
  FNowID := '';



  FileStr := FFileMemo;


    i := -1;
    While True do
    Begin
      Inc(i);

      If i>=FileStr.Count Then Break;

      S := FileStr.Strings[i];
      if Pos('<ID='+ID+'>',UpperCase(S))>0 Then
      Begin
           FNowID := ID;
           FMemo := GetSection(i,FileStr,'</ID>');
           Break;
      End;
    End;


Except
end;

Finally
End;


end;

procedure TCBPurposeMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;

procedure TCBPurposeMgr.SaveDocDat;
Procedure ReplaceSection(Var StratIndex: Integer;
f: TStringList; const Section: String;Const Memo:String);
Var
     i : integer;
     s,ts : String;
Begin
         ts := '';
         For i:=StratIndex+1 to f.Count-1 do
         Begin
            s := f.Strings[StratIndex+1];
            if Pos(Section,UpperCase(S))>0 Then
               Break;
            f.Delete(StratIndex+1);
         End;

         f.Insert(StratIndex+1,Memo);
         StratIndex := StratIndex+1;

end;
Var
  s : String;
  i :  integer;
Begin

Try
Try

   if Length(FNowID)=0 Then
      exit;

   if Not FNeedSave Then
      exit;

    i := -1;

    While True do
    Begin
      Inc(i);

      If i>=FFileMemo.Count Then Break;

      S := FFileMemo.Strings[i];

      if Pos('<ID='+FNowID+'>',UpperCase(S))>0 Then
      Begin
           ReplaceSection(i,FFileMemo,'</ID>',FMemo);
           Continue;
      End;
    End;


Except
end;

Finally
     FNeedSave := False;
End;


end;


procedure TACBPurposeFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBPurposeFrm.Txt_MemoChange(Sender: TObject);
begin
  if Not FLockMemoChange Then
  begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
    SaveDocData;
  end;
end;

procedure TACBPurposeFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TCBPurposeMgr.SetMemo(const Value: String);
begin
  FMemo := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBPurposeFrm.Refresh(const FileName: String);
begin
   ACBPurposeMgr.Reback(FileName);
   Init(FileName);
end;

procedure TACBPurposeFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBPurposeMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBPurposeFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBPurposeMgr.DelAID() Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Del',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      Txt_Memo.Clear;
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

procedure TACBPurposeFrm.Txt_IDChange(Sender: TObject);
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

function TACBPurposeFrm.NeedSave: Boolean;
begin
   Result := ACBPurposeMgr.FNeedSaveUpload
end;

procedure TACBPurposeFrm.BeSave;
begin
    ACBPurposeMgr.FNeedSaveUpload  := False;
end;

function TCBPurposeMgr.UpdateAID(var ID: String): Boolean;
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
          if Pos('<ID='+FNowID+'>',Str)>0 Then
          Begin
            FIDLst[i] := ID;
            ReplaceSubString('<ID='+FNowID+'>','<ID='+ID+'>',Str);
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

procedure TACBPurposeFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBPurposeMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;

{function TACBPurposeFrm.ChangeFont(TextStr:String):String;
var S:string;
    i:integer;
    CheckLength:integer;
begin
  Result:=TextStr;
  S:=TextStr;
  CheckLength:=length(S);
  if length(S)=0 then
     exit;
  while pos('',S)>0 do
  begin
    i:=pos('',S);
    S[i]:=' ';
  end;
  while pos('“',S)>0 do
  begin
    i:=pos('“',S);
    S[i]:=' ';
    S[i+1]:='"';
  end;
  while pos('”',S)>0 do
  begin
    i:=pos('”',S);
    S[i]:='"';
    S[i+1]:=' ';
  end;
  while pos('——',S)>0 do
  begin
    i:=pos('——',S);
    S[i]:='-';
    S[i+1]:=' ';
    S[i+2]:='-';
    S[i+3]:=' ';
  end;
  while pos('……',S)>0 do
  begin
    i:=pos('……',S);
    S[i]   := '.';
    S[i+1] := '.';
    S[i+2] := '.';
    S[i+3] := '.';
  end;
  while pos('—',S)>0 do
  begin
    i:=pos('—',S);
    S[i]:='-';
    S[i+1]:=' ';
  end;
  if CheckLength<>length(s) then
     exit;
  Result:=S;
end;}

procedure TACBPurposeFrm.RefID;
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
