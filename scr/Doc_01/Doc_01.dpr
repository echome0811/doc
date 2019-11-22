program Doc_01;

uses
  ShareMem,
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := false;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
