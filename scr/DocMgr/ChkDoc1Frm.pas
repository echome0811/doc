//修改拟发行公告不能审核问题20070808-by LB-modify
unit ChkDoc1Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,TDocMgr,CsDef, Buttons,TCommon, ComCtrls,Clipbrd;

type
  TAChkDoc1Frm = class(TForm)
    Bevel4: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Panel4: TPanel;
    Memo2: TMemo;
    Panel1: TPanel;
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    Panel5: TPanel;
    Bevel5: TBevel;
    Bevel1: TBevel;
    Memo1: TRichEdit;
    procedure Btn_SaveClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FStatus : TChkStatus;
  public
    { Public declarations }
    FMemo : String;
    FID : String;
    procedure SearchWord(const Word:String);
    function OpenChkFrm(const TxtMemo,TxtID:String;Const TxtTitle,KeyWord:String):TChkStatus;
  end;

var
  AChkDoc1Frm: TAChkDoc1Frm;

implementation

{$R *.dfm}

{ TAChkDoc1Frm }

function TAChkDoc1Frm.OpenChkFrm(const TxtMemo, TxtID,
  TxtTitle,KeyWord: String): TChkStatus;
var
  StrLst : _CStrLst;
  i : Integer;
begin

    Panel5.Caption  :=  FAppParam.ConvertString('功能列表');
    Button1.Caption :=  FAppParam.ConvertString('通过审核');
    Button2.Caption :=  FAppParam.ConvertString('取消离开');

    FMemo := '';
    FID   := '';
    Caption := TxtTitle;
    ////修改拟发行公告不能审核问题20070808-by LB-modify
    //------------------------------------------------
   try
    Memo1.Lines.Clear;
    ClipBoard.Clear;
    ClipBoard.SetTextBuf(PChar(TxtMemo));
    Memo1.PasteFromClipboard;
    ClipBoard.Clear;
    Memo2.Lines.Text := TxtID;
   except
   end;
  //-----------------------------------------------
    //Memo1.Lines.Text := TxtMemo;
//    Memo2.Lines.Text := TxtID;

    StrLst := DoStrArray(KeyWord,',');
    For i:=0 to High(StrLst) do
      SearchWord(Trim(StrLst[i]));

    Self.ShowModal;
    Result := FStatus;

end;

procedure TAChkDoc1Frm.Btn_SaveClick(Sender: TObject);
begin
   FMemo := Memo1.Lines.Text;
   FID   := Memo2.Lines.Text;
   ReplaceSubString(#10#13,',',FID);
   ReplaceSubString(#13#10,',',FID);
end;

procedure TAChkDoc1Frm.Button2Click(Sender: TObject);
begin
   FStatus := chkEsc;
   Close;
end;

procedure TAChkDoc1Frm.Button3Click(Sender: TObject);
begin
   FStatus := chkDel;
   Close;
end;

procedure TAChkDoc1Frm.Button1Click(Sender: TObject);
begin
   FStatus := chkOK;
   Close;
end;

procedure TAChkDoc1Frm.SearchWord(const Word: String);
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

end.
