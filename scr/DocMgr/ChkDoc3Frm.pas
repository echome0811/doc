unit ChkDoc3Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,TDocMgr,CsDef, Buttons;

type
  TAChkDoc3Frm = class(TForm)
    Bevel4: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Panel2: TPanel;
    Memo1: TMemo;
    Panel3: TPanel;
    Panel4: TPanel;
    Button1: TSpeedButton;
    Button2: TSpeedButton;
    Panel5: TPanel;
    Bevel5: TBevel;
    Bevel1: TBevel;
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
    function OpenChkFrm(const TxtMemo:String;Const TxtTitle:String):TChkStatus;
  end;

var
  AChkDoc3Frm: TAChkDoc3Frm;

implementation

{$R *.dfm}

{ TAChkDoc1Frm }

function TAChkDoc3Frm.OpenChkFrm(const TxtMemo,
  TxtTitle: String): TChkStatus;
begin

    Panel5.Caption  :=  FAppParam.ConvertString('功能列表');
    Button1.Caption :=  FAppParam.ConvertString('通过审核');
    Button2.Caption :=  FAppParam.ConvertString('取消离开');

    FMemo := '';
    Caption := TxtTitle;
    Memo1.Lines.Text := TxtMemo;
    Self.ShowModal;
    Result := FStatus;

end;

procedure TAChkDoc3Frm.Btn_SaveClick(Sender: TObject);
begin
   FMemo := Memo1.Lines.Text;
end;

procedure TAChkDoc3Frm.Button2Click(Sender: TObject);
begin
   FStatus := chkEsc;
   Close;
end;

procedure TAChkDoc3Frm.Button3Click(Sender: TObject);
begin
   FStatus := chkDel;
   Close;
end;

procedure TAChkDoc3Frm.Button1Click(Sender: TObject);
begin
   FStatus := chkOK;
   Close;
end;

end.
