//可兼容上传台湾交易提示   20071108
unit CBTodayHintFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,TDocMgr;

type
  TACBTodayHintFrm = class(TFrame)
    TxtBox: TGroupBox;
    Splitter1: TSplitter;
    ZZBox: TGroupBox;
    Splitter2: TSplitter;
    SZBox: TGroupBox;
    Txt_Memo: TRichEdit;
    ZZTxt_memo: TRichEdit;
    SZTxt_Memo: TRichEdit;
    procedure Txt_MemoChange(Sender: TObject);
  private
    { Private declarations }
    FNeedSaveUpload : Boolean;
    procedure SearchWord(const Word:String;IsZZ:boolean);
    procedure ClearWord(IsZZ:boolean);
    procedure ZZinit(FileName,IDLstFile:String);
    procedure SZinit(FileName,IDLstFile:String);
    procedure init(AcbtodayhintFilename,ZZ_IDLstFile,SZ_IDLstFile:String);
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;Const ZZ_FileName,ZZ_IDLstFile,SZ_FileName,SZ_IDLstFile,AcbtodayhintFilename:String);
    Procedure Refresh(Const ZZ_FileName,ZZ_IDLstFile,SZ_FileName,SZ_IDLstFile,AcbtodayhintFilename:String);
    Function GetMemoText():String;
    procedure BeSave();
    function NeedSave:Boolean;
  end;
var
  DocMgrParam:TDocMgrParam;  //for Taiwan Todayhint 20071108
implementation

{$R *.dfm}

{ TACBTodayHintFrm }

procedure TACBTodayHintFrm.BeSave;
begin
  FNeedSaveUpload := False;
end;

function TACBTodayHintFrm.GetMemoText: String;
begin
   //Result := Txt_Memo.Text;
   //将繁体转化为简体
   Result :=DocMgrParam.ConvertStringGB(Txt_Memo.Text); //20071108 for TaiwanTodayHint
end;

procedure TACBTodayHintFrm.ZZinit(FileName,IDLstFile: String);
Var
  f : TStringList;
  i : Integer;
  Word:ShortString;
begin
  if FileExists(fileName) Then
  Begin
    ZZTxt_Memo.Lines.LoadFromFile(fileName);
    ClearWord(true);
    if FileExists(IDLstFile) then
    begin
      f := TStringList.Create;
      f.LoadFromFile(IDLstFile);
      for i:=0 to f.Count-1 do
      begin
        Word:=f.Strings[i];
        SearchWord(Word,true);
      end;
      f.Free;
    end;
  End Else
  begin
    ZZTxt_Memo.Lines.Clear;
    Word:='[中国证券无今日最新交易提示]';
    ZZTxt_Memo.Lines.Text:=word;
    searchWord(Word,true);
  end;
end;

procedure TACBTodayHintFrm.SZinit(FileName, IDLstFile: String);
Var
  f : TStringList;
  i : Integer;
  Word:ShortString;
begin
  if FileExists(fileName) Then
  Begin
    SZTxt_Memo.Lines.LoadFromFile(fileName);
    ClearWord(False);
    if FileExists(IDLstFile) then
    begin
      f := TStringList.Create;
      f.LoadFromFile(IDLstFile);
      for i:=0 to f.Count-1 do
      begin
        Word:=f.Strings[i];
        SearchWord(Word,False);
      end;
      f.Free;
    end;
  End Else
  begin
    SZTxt_Memo.Lines.Clear;
    Word:='[上海证券无今日最新交易提示]';
    SZTxt_Memo.Lines.Text:=word;
    searchWord(Word,False);
  end;
end;

function TACBTodayHintFrm.NeedSave: Boolean;
begin
  Result := FNeedSaveUpload ;
end;

procedure TACBTodayHintFrm.Refresh(
  const ZZ_FileName,ZZ_IDLstFile,SZ_FileName,SZ_IDLstFile,AcbtodayhintFilename: String);
begin
    ZZinit(ZZ_FileName,ZZ_IDLstFile);
    SZinit(SZ_FileName,SZ_IDLstFile);
    init(AcbtodayhintFilename,ZZ_IDLstFile,SZ_IDLstFile);
end;

procedure TACBTodayHintFrm.SetInit(Parent: TWinControl;
  const ZZ_FileName,ZZ_IDLstFile,SZ_FileName,SZ_IDLstFile,AcbtodayhintFilename: String);
begin
    Self.Parent := Parent;
    Self.Align := alClient;
    ZZinit(ZZ_FileName,ZZ_IDLstFile);
    SZinit(SZ_FileName,SZ_IDLstFile);
    //for Taiwan Todayhint 20071108
    //******************************************************
    DocMgrParam:=TDocMgrParam.Create;
    TxtBox.Caption:=DocMgrParam.ConvertString('今日交易提示整理上传：');
    ZZBox.Caption:=DocMgrParam.ConvertString('中正今日交易提示：');
    SZBox.Caption:=DocMgrParam.ConvertString('上证今日交易提示：');
    //*************************************************************
    init(AcbtodayhintFilename,ZZ_IDLstFile,SZ_IDLstFile);
end;

procedure TACBTodayHintFrm.Txt_MemoChange(Sender: TObject);
begin
  FNeedSaveUpload := True;
end;

procedure TACBTodayHintFrm.init(AcbtodayhintFilename,ZZ_IDLstFile,SZ_IDLstFile:String);
var
  StrLst ,f: TStringList;
  i,nIndex, nPos : integer;
  s,Word : string;
begin
 Txt_Memo.Clear;
 StrLst := TStringList.Create;
 f := TStringList.Create;
Try
  StrLst.LoadFromFile(AcbtodayhintFilename);
  if(Copy(StrLst.Text,Pos('<DATE=',StrLst.Text)+length('<DATE='),8)=FormatDateTime('yyyymmdd',Date))then
  begin
    Txt_Memo.Text := Copy(StrLst.Text,
                          Pos('<HINT>',StrLst.Text)+length('<HINT>'),
                          Pos('</HINT>',StrLst.Text)-Pos('<HINT>',StrLst.Text)-length('<HINT>'));
    // ZZ
    if FileExists(ZZ_IDLstFile) then
    begin
      f.LoadFromFile(ZZ_IDLstFile);
      for i:=0 to f.Count-1 do
      begin
        Word := f.Strings[i];
        //SearchWord
        s :=Txt_Memo.Text;
        nPos := 1;
        nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
        while (nIndex > 0) do
        begin
          Txt_Memo.SelStart := nIndex + nPos - 2;
          Txt_Memo.SelLength := Length(Word);
          Txt_Memo.SelAttributes.Color := clRed;
          Txt_Memo.SelAttributes.Style := Txt_Memo.SelAttributes.Style + [fsUnderline];
          inc(nPos, nIndex + Length(Word)-1);    //重新定位起始点
          nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
        end;
      end;

    end;

    // SZ
    if FileExists(SZ_IDLstFile) then
    begin
      f.Clear;
      f.LoadFromFile(SZ_IDLstFile);
      for i:=0 to f.Count-1 do
      begin
        Word:=f.Strings[i];
        //SearchWord
        s :=Txt_Memo.Text;
        nPos := 1;
        nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
        while (nIndex > 0) do
        begin
          Txt_Memo.SelStart := nIndex + nPos - 2;
          Txt_Memo.SelLength := Length(Word);
          Txt_Memo.SelAttributes.Color := clRed;
          Txt_Memo.SelAttributes.Style := Txt_Memo.SelAttributes.Style + [fsUnderline];
          inc(nPos, nIndex + Length(Word)-1);    //重新定位起始点
          nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
        end;
      end;

    end;
  end;
Except
end;
  StrLst.Free;
  f.Free;
  FNeedSaveUpload := false;
end;
procedure TACBTodayHintFrm.SearchWord(const Word: String; IsZZ: boolean);
var
   nIndex, nPos : integer;
   s : string;
begin
  if IsZZ then  //中正窗口mark
  begin
    s :=ZZTxt_Memo.Text;
    nPos := 1;
    nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
    while (nIndex > 0) do
    begin
      ZZTxt_Memo.SelStart := nIndex + nPos - 2;
      ZZTxt_Memo.SelLength := Length(Word);
      ZZTxt_Memo.SelAttributes.Color := clRed;
      ZZTxt_Memo.SelAttributes.Style := ZZTxt_Memo.SelAttributes.Style + [fsUnderline];
      inc(nPos, nIndex + Length(Word)-1);    //重新定位起始点
      nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
    end;
  end
  else              //上证窗口mark
  begin
    s := SZTxt_Memo.Text;
    nPos := 1;
    nIndex := Pos(LowerCase(Word),LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
    while (nIndex > 0) do
    begin
      SZTxt_Memo.SelStart := nIndex + nPos - 2;
      SZTxt_Memo.SelLength := Length(Word);
      SZTxt_Memo.SelAttributes.Color := clRed;
      SZTxt_Memo.SelAttributes.Style :=SZTxt_Memo.SelAttributes.Style + [fsUnderline];
      inc(nPos, nIndex + Length(Word)-1);    //重新定位起始点
      nIndex := Pos(LowerCase(Word),
      LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
    end;
  end;
end;

procedure TACBTodayHintFrm.ClearWord(IsZZ:boolean);
begin
  //joysun 2005/12/15 防止一片红现象
  if(IsZZ)then
  begin
    //中正窗口mark
    ZZTxt_Memo.SelStart := 0;
    ZZTxt_Memo.SelLength := Length(ZZTxt_Memo.Text);
    ZZTxt_Memo.SelAttributes.Color := clBlack;
    ZZTxt_Memo.SelAttributes.Style :=[];
  end
  else
  begin
    //上证窗口mark
    SZTxt_Memo.SelStart := 0;
    SZTxt_Memo.SelLength := Length(SZTxt_Memo.Text);
    SZTxt_Memo.SelAttributes.Color := clBlack;
    SZTxt_Memo.SelAttributes.Style :=[];
  end;

end;



end.
