program Doc_ChinaTodayHint_SZ;



uses
  ShareMem,
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  TDocMgr in '..\TDefine\TDocMgr.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.ShowMainForm := false;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
