program DocCenter;

uses
  Forms,
  MainFrm in 'MainFrm.pas' {AMainFrm},
  uCBDataTokenMng in '..\TDefine\uCBDataTokenMng.pas',
  uLogHandleThread in '..\TDefine\uLogHandleThread.pas',
  uForUserMoudule in 'uForUserMoudule.pas',
  uThreeTraderPro in 'uThreeTraderPro.pas',
  uForCBOpCom in '..\TDefine\uForCBOpCom.pas',
  uFuncThread in 'uFuncThread.pas',
  uCbdataAndNodePro in 'uCbdataAndNodePro.pas',
  uSetWorkForIFRSFrm in 'uSetWorkForIFRSFrm.pas' {SetWorkForIFRSForm};

{$R *.res}

begin
  Application.Initialize;
  //Application.ShowMainForm := false;
  Application.CreateForm(TAMainFrm, AMainFrm);
  Application.CreateForm(TSetWorkForIFRSForm, SetWorkForIFRSForm);
  Application.Run;
end.
