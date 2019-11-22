unit uLogInFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,TCommon, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient,TDocMgr,TMsg;


type TCheckLogin=Procedure (UserId,Psw:String; var LoginOk:Boolean) of Object;

type
  TLogInForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    btnLogin: TButton;
    edtID: TEdit;
    edtPsw: TEdit;
    btnQuit: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnQuitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CheckLogin:TCheckLogin;
  end;

var
  LogInForm: TLogInForm;

implementation

{$R *.dfm}

procedure TLogInForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  LogInForm.Caption := FAppParam.ConvertString('��½');
  btnLogin.Caption := FAppParam.ConvertString('��½');
  btnQuit.Caption := FAppParam.ConvertString('�˳�');
  Label1.Caption := FAppParam.ConvertString('�û�����');
  Label2.Caption := FAppParam.ConvertString('���룺');
  {P_CurUser.ID := '';
  P_CurUser.Password := '';
  for i:=Low(P_CurUser.LookPurview) to High(P_CurUser.LookPurview) do
    P_CurUser.LookPurview[i]:=false;
  for i:=Low(P_CurUser.EditPurview) to High(P_CurUser.EditPurview) do
    P_CurUser.EditPurview[i]:=false;
  P_CurUser.SuperUser := false; }
end;

procedure TLogInForm.FormShow(Sender: TObject);
begin
  LogInForm.Caption := FAppParam.ConvertString('��½'); 
  edtID.Clear;
  edtID.SetFocus;
end;

procedure TLogInForm.btnQuitClick(Sender: TObject);
begin
  Halt;
end;


procedure TLogInForm.btnLoginClick(Sender: TObject);
var
    ID,Password:String;
    b,LoginOk:Boolean;//�Ƿ����κ�һ��Ȩ��
    i:integer;
begin
  ID:=Trim(edtID.Text);
  Password:=Trim(edtPsw.Text);

  {//������α�֤Admin�û�����ͨ��
  if (ID='sa') and (Password='sa') then
  begin
    //P_CurUser.ID:=ID;
    for i:=Low(P_CurUser.LookPurview) to High(P_CurUser.LookPurview) do
      P_CurUser.LookPurview[i]:=true;
    for i:=Low(P_CurUser.EditPurview) to High(P_CurUser.EditPurview) do
      P_CurUser.EditPurview[i]:=true;
    P_CurUser.SuperUser := true;
    LoginOk := true;
  end
  else begin
    if Assigned(CheckLogin) then
      CheckLogin(ID,Password,LoginOk);
  end; }

  if Assigned(CheckLogin) then
      CheckLogin(ID,Password,LoginOk);
      
  if not LoginOk then
  begin
    MsgHint('û�и��û������������');
    edtID.Clear;
    edtPsw.Clear;
    edtID.SetFocus;
  end
  else begin
    b:=false;
    for i:=0 to High(P_CurUser.LookPurview) do
      b:=(b or P_CurUser.LookPurview[i]);
    for i:=0 to High(P_CurUser.EditPurview) do
      b:=(b or P_CurUser.EditPurview[i]);
    if not b then
    begin
      MsgHint('��û���κβ���Ȩ��');
      Application.Terminate;
    end;
    P_CurUser.ID := edtID.Text;
    P_CurUser.Password := edtPsw.Text;
    ModalResult := mrOK;
  end;
end;

end.
