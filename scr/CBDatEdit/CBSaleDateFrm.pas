//--Doc4.0 需求4 huangcq090317 add 卖回日期，新增了本窗体,从赎回日期继承
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
  Btn_RedeemReason.Caption:=FAppParam.ConvertString('>>卖回原因');
  ListValue.Columns[4].Caption := FAppParam.ConvertString('卖回价格');
  ListValue.Columns[5].Caption := FAppParam.ConvertString('卖回原因');

end;

end.
