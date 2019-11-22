unit ChkDoc2Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,TDocMgr, Buttons,CsDef, ComCtrls,TCommon,Clipbrd;

type



  TAChkDoc2Frm = class(TForm)
    Bevel4: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TSpeedButton;
    Panel5: TPanel;
    Button2: TSpeedButton;
    Btn_Save: TSpeedButton;
    Button3: TSpeedButton;
    Bevel1: TBevel;
    Bevel5: TBevel;
    SpeedButton1: TSpeedButton;
    Memo1: TRichEdit;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
    FStatus : TChkStatus;
    FClassIndex : Integer;
    FID : String;
    procedure SearchWord(const Word:String);
  public

    { Public declarations }
    FMemo : String;

    function OpenChkFrm(const ClassIndex:Integer;Const ID:String;
                        const TxtMemo:String;Const TxtTitle:String;
                        const keyWord:String;const TxtHttp:String):TChkStatus;
  end;


implementation

{$R *.dfm}

{ TAChkDoc2Frm }

procedure TAChkDoc2Frm.Button1Click(Sender: TObject);
begin
   FStatus := chkOK;
   if Btn_Save.Enabled Then
      Btn_Save.Click;
   Close;
end;

function TAChkDoc2Frm.OpenChkFrm(const ClassIndex:Integer;
Const ID:String;const TxtMemo: String;Const TxtTitle:String;
const keyWord:String;const TxtHttp:String):TChkStatus;
Var
  StrLst : _CStrLst;
  i : Integer;
begin

    Panel5.Caption  :=  FAppParam.ConvertString('功能列表');
    Button1.Caption :=  FAppParam.ConvertString('通过审核');
    Button2.Caption :=  FAppParam.ConvertString('取消离开');
    Btn_Save.Caption :=  FAppParam.ConvertString('保存公告');
    SpeedButton1.Caption :=  FAppParam.ConvertString('转债资料');
    Button3.Caption :=  FAppParam.ConvertString('删除公告');

    Panel1.Caption := TxtHttp;
    FMemo := '';
    FClassIndex := ClassIndex;
    FID := ID;
    Caption := TxtTitle;
    Memo1.Clear;

    ClipBoard.Clear;
    ClipBoard.SetTextBuf(PChar(TxtMemo));
    Memo1.PasteFromClipboard;
    ClipBoard.Clear;
    //Memo1.Lines.Text := TxtMemo;

    StrLst := DoStrArray(KeyWord,';');
    For i:=0 to High(StrLst) do
      SearchWord(Trim(StrLst[i]));


    Btn_Save.Enabled := false;
    Self.ShowModal;
    Result := FStatus;
end;



procedure TAChkDoc2Frm.Button3Click(Sender: TObject);
begin
   //add by JoySun 2005/10/25
   if IDOK=MessageBox(Self.Handle ,
                      PChar(FAppParam.ConvertString('该公告删除后将不再被搜索，确认删除？')),
                      PChar(FAppParam.ConvertString('删除确认')),
                      MB_OKCANCEL+ MB_DEFBUTTON2+MB_ICONQUESTION) then
   begin
     FStatus := chkDel;
     Close;
   end;
end;

procedure TAChkDoc2Frm.Button2Click(Sender: TObject);
begin
   FStatus := chkEsc;
   Close;
end;

procedure TAChkDoc2Frm.Btn_SaveClick(Sender: TObject);
begin
   Btn_Save.Enabled := false;
   FMemo := Memo1.Lines.Text;
end;

procedure TAChkDoc2Frm.Memo1Change(Sender: TObject);
begin
   Btn_Save.Enabled := true;
end;

procedure TAChkDoc2Frm.SpeedButton1Click(Sender: TObject);
Var
  Str : PChar;
begin
   if Length(FID)=0 Then
      Str := PChar(ExtractFilePath(Application.ExeName)+'CBDatEdit.Exe')
   Else
      Str := PChar(ExtractFilePath(Application.ExeName)+
           'CBDatEdit.Exe '+FID+' ' +IntToStr(FClassIndex));
   WinExec(Str,0);
end;

procedure TAChkDoc2Frm.SearchWord(const Word: String);
var
   nIndex, nPos : integer;
   s : string;
begin


        s := Memo1.Text;
	nPos := 1;
	nIndex := Pos(LowerCase(Word),
                      LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
	while (nIndex > 0) do
	begin
             Memo1.SelStart := nIndex + nPos - 2;
             Memo1.SelLength := Length(Word);
             Memo1.SelAttributes.Color := clRed;
             Memo1.SelAttributes.Style := Memo1.SelAttributes.Style + [fsUnderline];
             inc(nPos, nIndex + Length(Word)-1);    //重新定位起始点
             nIndex := Pos(LowerCase(Word),
             LowerCase(Copy(s, nPos, Length(s) - nPos + 1)));
	end;


   
end;

procedure TAChkDoc2Frm.Panel1Click(Sender: TObject);
begin
  OpenWithIE(Panel1.Caption);
end;

End.
