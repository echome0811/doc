program Doc_DwnHtml;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  TGetDocMgr in 'TGetDocMgr.pas',
  SetupFrm in 'SetupFrm.pas' {ASetupFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
