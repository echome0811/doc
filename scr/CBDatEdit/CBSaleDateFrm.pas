//--Doc4.0 ����4 huangcq090317 add �������ڣ������˱�����,��������ڼ̳�
unit CBSaleDateFrm;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CBRedeemDateFrm;

type
  TACBSaleDateFrm = class(TACBRedeemDateFrm)//TFrame    
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure SetInit(Parent:TWinControl;Const FileName,pIdLstFile:String);override;
  end;

implementation

uses
 ReasonEditFrm,TDocMgr;

{$R *.dfm}

procedure TACBSaleDateFrm.SetInit(Parent: TWinControl; const FileName,
  pIdLstFile: String);
begin
  inherited;

  FReasonTag:=RsnTypeSale;
  Btn_RedeemReason.Caption:=FAppParam.ConvertString('>>����ԭ��');
  ListValue.Columns[4].Caption := FAppParam.ConvertString('���ؼ۸�');
  ListValue.Columns[5].Caption := FAppParam.ConvertString('����ԭ��');

end;

end.
