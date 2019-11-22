program CnErrDocPro;

uses
  Forms,
  uMainFrm in 'uMainFrm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
