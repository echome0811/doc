unit DatPackageSetupFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ComCtrls, CsDef,ExtCtrls,TCommon;

type
  TADatPackageSetupFrm = class(TForm)
    Bevel2: TBevel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Label7: TLabel;
    Txt_Tr1DBPath: TEdit;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Label11: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Label28: TLabel;
    Label17: TLabel;
    Chk_FtpPasv: TCheckBox;
    Txt_FtpServer: TEdit;
    Txt_FtpPort: TEdit;
    Txt_FtpPass: TEdit;
    Txt_FtpUser: TEdit;
    Txt_FtpUploadDir: TEdit;
    Button5: TButton;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Button1: TButton;
    Label1: TLabel;
    Txt_DBPath: TEdit;
    Button2: TButton;
    Label2: TLabel;
    Txt_CBPAPath: TEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    SaveOk : Boolean;
    function CheckInputData():Boolean;
  public
    { Public declarations }
    function Open():Boolean;
  end;

var
  ADatPackageSetupFrm: TADatPackageSetupFrm;

implementation

{$R *.dfm}

{ TADatPackageSetupFrm }

function TADatPackageSetupFrm.CheckInputData: Boolean;
begin

     Result := false;

      Txt_Tr1DBPath.Text := Trim(Txt_Tr1DBPath.Text);
      if Length(Txt_Tr1DBPath.Text)=0 Then
      Begin
          Application.MessageBox('请输入,TR1DB的路径.','注意',0);
          exit;
      End;

      Txt_DBPath.Text := Trim(Txt_DBPath.Text);
      if Length(Txt_DBPath.Text)=0 Then
      Begin
          Application.MessageBox('请输入,打包数据保存路径.','注意',0);
          exit;
      End;

      Txt_CBPAPath.Text := Trim(Txt_CBPAPath.Text);
      if Length(Txt_CBPAPath.Text)=0 Then
      Begin
          Application.MessageBox('请输入,CBPA路径.','注意',0);
          exit;
      End;


      Txt_FtpPort.Text := Trim(Txt_FTPPort.Text);
      if not IsInteger(PChar(Txt_FTPPort.Text)) Then
      Begin
          Application.MessageBox('请输入正确上传服务器端口.','注意',0);
          exit;
      End;

      Txt_FTPServer.Text := Trim(Txt_FTPServer.Text);
      if Length(Txt_FTPServer.Text)=0 Then
      Begin
          Application.MessageBox('请输入,上传服务器.','注意',0);
          exit;
      End;
      Txt_FTPUploadDir.Text := Trim(Txt_FTPUploadDir.Text);
      Txt_FtpUser.Text := Trim(Txt_FtpUser.Text);
      Txt_FtpPass.Text := Trim(Txt_FtpPass.Text);

      Result := True;


end;

function TADatPackageSetupFrm.Open: Boolean;
begin

   SaveOk := False;

   Self.ShowModal;

   Result := SaveOk;

end;

procedure TADatPackageSetupFrm.Button1Click(Sender: TObject);
begin
  Txt_Tr1DBPath.Text:=SelDir('');
end;

procedure TADatPackageSetupFrm.Button2Click(Sender: TObject);
begin
  Txt_DBPath.Text:=SelDir('');
end;

procedure TADatPackageSetupFrm.OKBtnClick(Sender: TObject);
begin

  if CheckInputData Then
  Begin
    SaveOK := True;
    Close;
  End;


end;

procedure TADatPackageSetupFrm.CancelBtnClick(Sender: TObject);
begin
  SaveOk := False;
  Close;

end;

procedure TADatPackageSetupFrm.Button3Click(Sender: TObject);
begin
  Txt_CBPAPath.Text:=SelDir('');
end;

end.
