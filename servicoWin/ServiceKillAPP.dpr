program ServiceKillAPP;

uses
  Vcl.SvcMgr,
  uControllerIniFile in 'uControllerIniFile.pas',
  principal in 'principal.pas' {Service1: TService};

{$R *.RES}

begin

  if not Application.DelayInitialize or Application.Installing then
    Application.Initialize;
  Application.CreateForm(TService1, Service1);
  Application.Run;
end.
