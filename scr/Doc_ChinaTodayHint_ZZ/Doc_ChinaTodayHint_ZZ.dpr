program Doc_ChinaTodayHint_ZZ;

uses
  ShareMem,
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  TDocMgr in '..\TDefine\TDocMgr.pas',
  uDllUrlHandle in 'uDllUrlHandle.pas',
  TodayHint_ZZ_Set in 'TodayHint_ZZ_Set.pas' {AFrmSetHint_ZZ};

{$R *.res}

begin
  Application.Initialize;
  //Application.ShowMainForm := false;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
