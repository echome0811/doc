unit CBDocFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,csDef, Buttons,TCBDatEditUnit, ComCtrls,
  TDocMgr
  ,TCommon;

type

  TCBDocMgr=Class
  private
    FFileName : String;
    FIDLst : Array of String;
    FNowID : String;
    FPut: String;
    FScale: String;
    FReset: String;
    FInterest: String;
    FFPut: String;
    FStrike: String;
    FCMonth: String;
    FCall: String;
    FDur: String;
    FFileMemo:TStringList;
    FNeedSave : Boolean;
    FNeedSaveUpload : Boolean;
    procedure Init();
    function GetID(Index: Integer): String;
    function GetIDCount: Integer;
    procedure SetCall(const Value: String);
    procedure SetCMonth(const Value: String);
    procedure SetDur(const Value: String);
    procedure SetFPut(const Value: String);
    procedure SetInterest(const Value: String);
    procedure SetPut(const Value: String);
    procedure SetReset(const Value: String);
    procedure SetScale(const Value: String);
    procedure SetStrike(const Value: String);
  public
    Constructor Create(Const FileName:String);
    Destructor Destroy();Override;
    procedure ReadDocDat(Const ID:String);
    procedure SaveDocDat();
    procedure DelDocDat();
    Function CreateAID(Var ID:String):Boolean;
    Function DelAID():Boolean;
    Function UpdateAID(Var ID:String):Boolean;
    procedure Reback(Const FileName:String);
    Function GetMemoText():String;
    property IDCount:Integer read GetIDCount;
    property ID[Index:Integer]:String read GetID;
    property ScaleStr: String read FScale write SetScale;
    property DurStr: String read FDur write SetDur;
    property StrikeStr: String read FStrike write SetStrike;
    property CMonthStr: String read FCMonth write SetCMonth;
    property InterestStr: String read FInterest write SetInterest;
    property ResetStr: String read FReset write SetReset;
    property CallStr: String read FCall write SetCall;
    property PutStr: String read FPut write SetPut;
    property FPutStr: String read FFPut write SetFPut;
  End;

  TACBDocFrm = class(TFrame)
    Panel_Left: TPanel;
    Panel_Right: TPanel;
    List_ID: TListBox;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Txt_ID: TEdit;
    Bevel2: TBevel;
    Panel_NowID: TPanel;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    Txt_Memo: TMemo;
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
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
   
  private
    { Private declarations }
    ACBDocMgr : TCBDocMgr;
    FLockMemoChange : Boolean;
    procedure Init(Const FileName:String);

  //  Function ChangeFont(TextStr:String):String;
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

Const
  SectionCaption : Array[0..8] of String=('发行规模','存续期间',
     '转股价格','转股月份','票面利率','重设条款','赎回条款','回售条款',
     '定点回售');

  SectionKey : Array[0..8] of String=('Scale','Dur',
     'Strike','CMonth','Interest','Reset','Call','Put',
     'FPut');




implementation

{$R *.dfm}

{ TACBDocFrm }

procedure TACBDocFrm.Init(Const FileName:String);
Var
  i : Integer;
begin

   FLockMemoChange := True;

   For i:=0 to High(SectionCaption) do
       PageControl1.Pages[i].Caption := FAppParam.ConvertString(SectionCaption[i]);

   Txt_ID.Text := '';
   Txt_Memo.Text := '';


   if Not Assigned(ACBDocMgr) Then
      ACBDocMgr := TCBDocMgr.Create(FileName);

   BeSave;

   List_ID.Clear;
   For i:=0 to ACBDocMgr.IDCount-1 do
       List_ID.Items.Add(ACBDocMgr.ID[i]);

   FLockMemoChange := false;

   if List_ID.Count>0 Then
   Begin
      List_ID.ItemIndex := GetItemIndex(List_ID);
      LoadDocData;
      ShowLoadDocData;
   End;
   
end;

procedure TACBDocFrm.LoadDocData;
Var
  ID : String;
begin
  if List_ID.ItemIndex<0 Then Exit;
  ID :=  List_ID.Items[List_ID.ItemIndex];
  Panel_NowID.Caption := Format(FAppParam.ConvertString('目前正在编辑代码: %s'),[ID]);
  ACBDocMgr.ReadDocDat(ID);
end;

procedure TACBDocFrm.SetInit(Parent: TWinControl;Const FileName:String);
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

procedure TACBDocFrm.ShowLoadDocData;
begin

    FLockMemoChange := True;
Try


   if SectionKey[PageControl1.ActivePageIndex]='Scale' Then
      Txt_Memo.Text := ACBDocMgr.ScaleStr;

   if SectionKey[PageControl1.ActivePageIndex]='Dur' Then
      Txt_Memo.Text := ACBDocMgr.DurStr;

   if SectionKey[PageControl1.ActivePageIndex]='Strike' Then
      Txt_Memo.Text := ACBDocMgr.StrikeStr;

   if SectionKey[PageControl1.ActivePageIndex]='CMonth' Then
      Txt_Memo.Text := ACBDocMgr.CMonthStr;

   if SectionKey[PageControl1.ActivePageIndex]='Interest' Then
      Txt_Memo.Text := ACBDocMgr.InterestStr;

   if SectionKey[PageControl1.ActivePageIndex]='Reset' Then
      Txt_Memo.Text := ACBDocMgr.ResetStr;

   if SectionKey[PageControl1.ActivePageIndex]='Call' Then
      Txt_Memo.Text := ACBDocMgr.CallStr;

   if SectionKey[PageControl1.ActivePageIndex]='Put' Then
      Txt_Memo.Text := ACBDocMgr.PutStr;

   if SectionKey[PageControl1.ActivePageIndex]='FPut' Then
      Txt_Memo.Text := ACBDocMgr.FPutStr;
      
Finally
   FLockMemoChange := false;
End;

end;

procedure TACBDocFrm.SaveDocData;
begin
   if PageControl1.ActivePageIndex<0 Then
      Exit;

   if SectionKey[PageControl1.ActivePageIndex]='Scale' Then
      ACBDocMgr.ScaleStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Dur' Then
      ACBDocMgr.DurStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Strike' Then
      ACBDocMgr.StrikeStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='CMonth' Then
      ACBDocMgr.CMonthStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Interest' Then
      ACBDocMgr.InterestStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Reset' Then
      ACBDocMgr.ResetStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Call' Then
      ACBDocMgr.CallStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='Put' Then
      ACBDocMgr.PutStr := Txt_Memo.Text;

   if SectionKey[PageControl1.ActivePageIndex]='FPut' Then
      ACBDocMgr.FPutStr := Txt_Memo.Text;
      
end;

function TACBDocFrm.GetMemoText: String;
begin

  Result := '';
  if Assigned(ACBDocMgr) Then
     Result := ACBDocMgr.GetMemoText;  

end;

procedure TACBDocFrm.Refresh(const FileName: String);
begin
   ACBDocMgr.Reback(FileName);
   Init(FileName);
end;

function TACBDocFrm.NeedSave: Boolean;
begin
  Result := ACBDocMgr.FNeedSaveUpload;
end;

procedure TACBDocFrm.BeSave;
begin
   ACBDocMgr.FNeedSaveUpload := False;
end;

{function TACBDocFrm.ChangeFont(TextStr: String): String;
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
end; }

procedure TACBDocFrm.RefID;
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

{ TCBDocMgr }

constructor TCBDocMgr.Create(Const FileName:String);
begin
  FFileName := FileName;
  FFileMemo := TStringList.Create;
  Init;
end;

function TCBDocMgr.CreateAID(var ID: String): Boolean;
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
   FFileMemo.Add('<Scale>');
   FFileMemo.Add('</Scale>');
   FFileMemo.Add('<Dur>');
   FFileMemo.Add('</Dur>');
   FFileMemo.Add('<Strike>');
   FFileMemo.Add('</Strike>');
   FFileMemo.Add('<CMonth>');
   FFileMemo.Add('</CMonth>');
   FFileMemo.Add('<Interest>');
   FFileMemo.Add('</Interest>');
   FFileMemo.Add('<Reset>');
   FFileMemo.Add('</Reset>');
   FFileMemo.Add('<Call>');
   FFileMemo.Add('</Call>');
   FFileMemo.Add('<Put>');
   FFileMemo.Add('</Put>');
   FFileMemo.Add('<FPut>');
   FFileMemo.Add('</FPut>');
   FFileMemo.Add('</ID>');

   ReadDocDat(ID);

   Result := True;

end;

function TCBDocMgr.DelAID: Boolean;
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

procedure TCBDocMgr.DelDocDat;
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

destructor TCBDocMgr.Destroy;
begin

  FFileMemo.Free;
  //inherited;
end;

function TCBDocMgr.GetID(Index: Integer): String;
begin
   Result := FIDLst[Index];
end;

function TCBDocMgr.GetIDCount: Integer;
begin
   Result := High(FIDLst)+1;
end;

function TCBDocMgr.GetMemoText: String;
begin
  SaveDocDat;
  FFileMemo.Text := Trim2String(FFileMemo);
  Result := FFileMemo.Text;
end;

procedure TCBDocMgr.Init;
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


procedure TCBDocMgr.ReadDocDat(const ID: String);
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
  GetID : Boolean;
  FileStr : TStringList;
  i:  integer;
Begin

Try
Try

  SaveDocDat;

  FScale := '';
  FDur := '';
  FStrike := '';
  FCMonth := '';
  FInterest := '';
  FReSet := '';
  FCall := '';
  FPut  := '';
  FFPut := '';
  FNowID := '';


  GetID := False;

  FileStr := FFileMemo;


    i := -1;

    While True do
    Begin
      Inc(i);

      If i>=FileStr.Count Then Break;

      S := FileStr.Strings[i];

      if not GetID Then
         if Pos('<',s)=0 Then
           Continue;

      if Pos(UpperCase('<ID='+ID+'>'),UpperCase(S))>0 Then
      Begin
           FNowID := ID;
           GetID    := True;
           Continue;
      End;

      if GetID Then
      Begin
          if Pos('</ID>',UpperCase(S))>0 Then
              Break;

          if Pos('<SCALE>',UpperCase(S))>0 Then
          Begin
            FScale := GetSection(i,FileStr,'</SCALE>');
            Continue;
          End;
          if Pos('<DUR>',UpperCase(S))>0 Then
          Begin
            FDur := GetSection(i,FileStr,'</DUR>');
            Continue;
          End;
          if Pos('<STRIKE>',UpperCase(S))>0 Then
          Begin
            FStrike := GetSection(i,FileStr,'</STRIKE>');
            Continue;
          End;
          if Pos('<CMONTH>',UpperCase(S))>0 Then
          Begin
            FCMonth := GetSection(i,FileStr,'</CMONTH>');
            Continue;
          End;
          if Pos('<INTEREST>',UpperCase(S))>0 Then
          Begin
            FInterest := GetSection(i,FileStr,'</INTEREST>');
            Continue;
          End;
          if Pos('<RESET>',UpperCase(S))>0 Then
          Begin
            FReset := GetSection(i,FileStr,'</RESET>');
            Continue;
          End;
          if Pos('<CALL>',UpperCase(S))>0 Then
          Begin
            FCall := GetSection(i,FileStr,'</CALL>');
            Continue;
          End;
          if Pos('<PUT>',UpperCase(S))>0 Then
          Begin
            FPut :=GetSection(i,FileStr,'</PUT>');
            Continue;
          End;
          if Pos('<FPUT>',UpperCase(S))>0 Then
          Begin
            FFPut := GetSection(i,FileStr,'</FPUT>');
            Continue;
          End;
      End;
    End;


Except
end;

Finally
End;


end;

procedure TCBDocMgr.Reback(const FileName: String);
begin
  FFileName := FileName;
  FNowID := '';
  Init;
end;


procedure TCBDocMgr.SaveDocDat;
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
  GetID : Boolean;
  i :  integer;
Begin

Try
Try

  if Length(FNowID)=0 Then
     exit;

  if not FNeedSave Then
     Exit;

  GetID := False;

    i := -1;

    While True do
    Begin
      Inc(i);

      If i>=FFileMemo.Count Then Break;

      S := FFileMemo.Strings[i];

      if not GetID Then
         if Pos('<',s)=0 Then
           Continue;


      if Pos(UpperCase('<ID='+FNowID+'>'),UpperCase(S))>0 Then
      Begin
           GetID    := True;
           Continue;
      End;

      if GetID Then
      Begin
          if Pos('</ID>',UpperCase(S))>0 Then
          Begin
              Break;
          End;

          if Pos('<SCALE>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</SCALE>',FSCale);
            Continue;
          End;
          if Pos('<DUR>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</DUR>',FDur);
            Continue;
          End;
          if Pos('<STRIKE>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</STRIKE>',FStrike);
            Continue;
          End;
          if Pos('<CMONTH>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</CMONTH>',FCMonth);
            Continue;
          End;
          if Pos('<INTEREST>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</INTEREST>',FInterest);
            Continue;
          End;
          if Pos('<RESET>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</RESET>',FReset);
            Continue;
          End;
          if Pos('<CALL>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</CALL>',FCall);
            Continue;
          End;
          if Pos('<PUT>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</PUT>',FPut);
            Continue;
          End;
          if Pos('<FPUT>',UpperCase(S))>0 Then
          Begin
            ReplaceSection(i,FFileMemo,'</FPUT>',FFPut);
            Continue;
          End;
      End;
    End;


Except
end;

Finally
  FNeedSave := False;
End;


end;

procedure TCBDocMgr.SetCall(const Value: String);
begin
  FCall := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetCMonth(const Value: String);
begin
  FCMonth := Value;

  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetDur(const Value: String);
begin
  FDur := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetFPut(const Value: String);
begin
  FFPut := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetInterest(const Value: String);
begin
  FInterest := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetPut(const Value: String);
begin
  FPut := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetReset(const Value: String);
begin
  FReset := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetScale(const Value: String);
begin
  FScale := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TCBDocMgr.SetStrike(const Value: String);
begin
  FStrike := Value;
  FNeedSave := True;
  FNeedSaveUpload := True;
end;

procedure TACBDocFrm.Cbo_SectionChange(Sender: TObject);
begin
  ShowLoadDocData;
end;

procedure TACBDocFrm.Txt_MemoChange(Sender: TObject);
begin
   if Not FLockMemoChange Then
   begin
    WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
    SaveDocData;
  end;
end;

procedure TACBDocFrm.List_IDClick(Sender: TObject);
begin
   LoadDocData;
   ShowLoadDocData;
end;

procedure TACBDocFrm.SpeedButton1Click(Sender: TObject);
Var
  ID : String;
begin

   if ACBDocMgr.CreateAID(ID) Then
   Begin
      WriteARecLog(ID,'Add',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.ItemIndex := List_ID.Items.Add(ID);
      LoadDocData;
      ShowLoadDocData;
   End;

end;

procedure TACBDocFrm.SpeedButton2Click(Sender: TObject);
Var
  Index : Integer;
begin

Try

   if List_ID.ItemIndex<0 Then
      exit;

   if Not (IDOK=MessageBox(Self.Handle ,PChar(FAppParam.ConvertString('确定删除!!'))
                      ,PChar(FAppParam.ConvertString('确认')),MB_OKCANCEL + MB_DEFBUTTON2+MB_ICONQUESTION)) then
   Exit;

   if ACBDocMgr.DelAID() Then
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

procedure TACBDocFrm.Txt_IDChange(Sender: TObject);
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

procedure TACBDocFrm.PageControl1Change(Sender: TObject);
begin
  Txt_Memo.Parent :=  PageControl1.ActivePage;
  ShowLoadDocData;
end;

function TCBDocMgr.UpdateAID(var ID: String): Boolean;
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

procedure TACBDocFrm.SpeedButton3Click(Sender: TObject);
Var
  ID : String;
begin

   if List_ID.ItemIndex<0 Then
      exit;

   if ACBDocMgr.UpdateAID(ID) Then
   Begin
      WriteARecLog(List_ID.Items[List_ID.ItemIndex],'Upt',P_CurUser.ID,Self.Caption,Self.Name);//add by wangjinhua 20090626 Doc4.3
      List_ID.Items[List_ID.ItemIndex] := ID;
   End;

end;


end.
