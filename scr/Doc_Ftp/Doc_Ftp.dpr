program Doc_Ftp;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
