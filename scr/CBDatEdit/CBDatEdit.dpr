program CBDatEdit;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  CBIssue2Frm in 'CBIssue2Frm.pas' {ACBIssue2Frm: TFrame},
  CBDocFrm in 'CBDocFrm.pas' {ACBDocFrm: TFrame},
  CBPurposeFrm in 'CBPurposeFrm.pas' {ACBPurposeFrm: TFrame},
  CBStockHolderFrm in 'CBStockHolderFrm.pas' {ACBStockHolderFrm: TFrame},
  CBStopIssueDocFrm in 'CBStopIssueDocFrm.pas' {ACBStopIssueDocFrm: TFrame},
  CBBaseInfoFrm in 'CBBaseInfoFrm.pas' {ACBBaseInfoFrm: TFrame},
  TCBDatEditUnit in 'TCBDatEditUnit.pas',
  CBIdxFrm in 'CBIdxFrm.pas' {ACBIdxFrm: TFrame},
  CBDateFrm in 'CBDateFrm.pas' {ACBDateFrm: TFrame},
  CBStrike3Frm in 'CBStrike3Frm.pas' {ACBStrike3Frm: TFrame},
  CBBondFrm in 'CBBondFrm.pas' {ACBBondFrm: TFrame},
  CBIssueFrm in 'CBIssueFrm.pas' {ACBIssueFrm: TFrame},
  CBStike2Frm in 'CBStike2Frm.pas' {ACBStike2Frm: TFrame},
  ShenBaoSetFrm in 'ShenBaoSetFrm.pas' {AShenBaoSetFrm: TFrame},
  CBDealerFrm in 'CBDealerFrm.pas' {ACBDealerFrm: TFrame},
  CBStopConvFrm in 'CBStopConvFrm.pas' {ACBStopConvFrm: TFrame},
  CBRedeemDateFrm in 'CBRedeemDateFrm.pas' {ACBRedeemDateFrm: TFrame},
  CBSaleDateFrm in 'CBSaleDateFrm.pas',
  ReasonEditFrm in 'ReasonEditFrm.pas' {AReasonEditFrm},
  CBDateTwFrm in 'CBDateTwFrm.pas' {ACBDateTwFrm: TFrame},
  uLogInFrm in 'uLogInFrm.pas' {LogInForm},
  uUserMngFrm in 'uUserMngFrm.pas' {UserMngForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.CreateForm(TLogInForm, LogInForm);
  Application.CreateForm(TUserMngForm, UserMngForm);
  Application.Run;
end.
