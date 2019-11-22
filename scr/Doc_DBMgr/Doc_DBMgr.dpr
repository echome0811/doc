program Doc_DBMgr;

uses
  Forms,windows,
  uMainFrm in 'uMainFrm.pas' {AMainFrm};

{$R *.res}

begin
  Application.Initialize;
  if(FindWindow('TAMainFrm',PChar('CBDatEdit And Document Server Center'))<>0)then
  begin
    Application.MessageBox(Pchar('                                  DocCenter now is running!'+#13+
                                 'To make sure the DocCenter was closed before running the program!'),Pchar('Warning'));
    Application.terminate;
  end;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
