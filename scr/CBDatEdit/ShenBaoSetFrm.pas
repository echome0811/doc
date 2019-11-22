
unit ShenBaoSetFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls,TDocMgr;

type
  TAShenBaoSetFrm = class(TFrame)
    TxtBox: TGroupBox;
    Splitter1: TSplitter;
    Txt_Memo: TRichEdit;
    procedure Txt_MemoChange(Sender: TObject);
  private
    { Private declarations }
    FNeedSaveUpload : Boolean;
    procedure init(AcbtodayhintFilename:String);
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;const AcbtodayhintFilename: String);
    procedure Refresh(const AcbtodayhintFilename: String);
    Function GetMemoText():String;
    procedure BeSave();
    function NeedSave:Boolean;
  end;

implementation

{$R *.dfm}

{ TACBTodayHintFrm }

procedure TAShenBaoSetFrm.BeSave;
begin
  FNeedSaveUpload := False;
end;

function TAShenBaoSetFrm.GetMemoText: String;
begin
   //Result := Txt_Memo.Text;
   //将繁体转化为简体
   //Result :=DocMgrParam.ConvertStringGB(Txt_Memo.Text); //20071108 for TaiwanTodayHint
   Result :=(Txt_Memo.Text); 
end;

function TAShenBaoSetFrm.NeedSave: Boolean;
begin
  Result := FNeedSaveUpload ;
end;

procedure TAShenBaoSetFrm.Refresh(const AcbtodayhintFilename: String);
begin
    init(AcbtodayhintFilename);
end;

procedure TAShenBaoSetFrm.SetInit(Parent: TWinControl;
  const AcbtodayhintFilename: String);
begin
    Self.Parent := Parent;
    Self.Align := alClient;
    init(AcbtodayhintFilename);
end;

procedure TAShenBaoSetFrm.Txt_MemoChange(Sender: TObject);
begin
  FNeedSaveUpload := True;
end;

procedure TAShenBaoSetFrm.init(AcbtodayhintFilename:String);
begin
  Txt_Memo.Clear;
  if not FileExists(AcbtodayhintFilename) then exit;
  Txt_Memo.lines.LoadFromFile(AcbtodayhintFilename);
  FNeedSaveUpload := false;
end;

end.
