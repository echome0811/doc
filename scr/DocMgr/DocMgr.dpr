program DocMgr;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  ViewDocFrm in 'ViewDocFrm.pas' {AViewDocFrm},
  ChkDoc3Frm in 'ChkDoc3Frm.pas' {AChkDoc3Frm},
  ChkDoc1Frm in 'ChkDoc1Frm.pas' {AChkDoc1Frm},
  ChkDoc2Frm in 'ChkDoc2Frm.pas' {AChkDoc2Frm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.Run;
end.
