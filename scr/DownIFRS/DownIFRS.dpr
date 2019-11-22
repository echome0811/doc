program DownIFRS;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  TDocMgr in '..\TDefine\TDocMgr.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
