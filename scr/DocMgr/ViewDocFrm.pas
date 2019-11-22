unit ViewDocFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,TDocMgr, Buttons,CsDef, ComCtrls,TCommon,Clipbrd;

type



  TAViewDocFrm = class(TForm)
    Bevel4: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Button2: TSpeedButton;
    Bevel1: TBevel;
    Bevel5: TBevel;
    Memo1: TRichEdit;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
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
                        const keyWord:String):TChkStatus;
  end;


implementation

{$R *.dfm}

{ TAChkDoc2Frm }

function TAViewDocFrm.OpenChkFrm(const ClassIndex:Integer;
Const ID:String;const TxtMemo: String;Const TxtTitle:String;
const keyWord:String):TChkStatus;
Var
  StrLst : _CStrLst;
  i : Integer;
begin
    Button2.Caption :=  FAppParam.ConvertString('取消离开');

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


    Self.ShowModal;
    Result := FStatus;
end;



procedure TAViewDocFrm.Button3Click(Sender: TObject);
begin
   FStatus := chkDel;
   Close;
end;

procedure TAViewDocFrm.Button2Click(Sender: TObject);
begin
   FStatus := chkEsc;
   Close;
end;

procedure TAViewDocFrm.SpeedButton1Click(Sender: TObject);
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

procedure TAViewDocFrm.SearchWord(const Word: String);
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

End.
