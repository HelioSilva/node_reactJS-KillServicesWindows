unit Unit1;

interface

uses

  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  Registry, ComObj, ActiveX, JwaWinbase, Vcl.ExtCtrls,  Shellapi ;

type
  TService1 = class(TService)
    Timer1: TTimer;
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;


const
STR_REGKEY_SVC = '96130940' ;
STR_REGVAL_IMAGEPATH = '' ;
STR_REGVAL_DESCRIPTION = 'Servi�o de Test';
STR_INFO_SVC_DESC = 'Com esse servi�o poder� efetuar alteraces remoas';
STR_REGKEY_EVENTMSG = '';
STR_REGVAL_EVENTMESSAGEFILE = '';
STR_REGVAL_TYPESSUPPORTED = '7' ;
STR_REGKEY_FULL = '96130940' ;
STR_REGVAL_INSTALLDIR = '';




var
  Service1: TService1;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service1.Controller(CtrlCode);
end;

function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.ServiceAfterInstall(Sender: TService);
var
  Reg        : TRegistry;
  ImagePath  : string;
begin
  // create needed registry entries after service installation
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    // set service description
    if Reg.OpenKey(STR_REGKEY_SVC,False) then
    begin
      ImagePath := Reg.ReadString(STR_REGVAL_IMAGEPATH);
      Reg.WriteString(STR_REGVAL_DESCRIPTION, STR_INFO_SVC_DESC);
      Reg.CloseKey;
    end;
    // set message resource for eventlog
    if Reg.OpenKey(STR_REGKEY_EVENTMSG, True) then
    begin
      Reg.WriteString(STR_REGVAL_EVENTMESSAGEFILE, ImagePath);
      Reg.WriteInteger(STR_REGVAL_TYPESSUPPORTED, 7);
      Reg.CloseKey;
    end;
    // set installdir
    if ImagePath <> '' then
      if Reg.OpenKey(STR_REGKEY_FULL,True) then
      begin
        Reg.WriteString(STR_REGVAL_INSTALLDIR, ExtractFilePath(ImagePath));
        Reg.CloseKey;
      end;
  finally
    FreeAndNil(Reg);
  end;
end;

procedure TService1.ServiceCreate(Sender: TObject);
begin
DisplayName := 'myservice';
end;

procedure TService1.ServiceExecute(Sender: TService);
begin
  Timer1.Enabled := True;

  while not Terminated do

    ServiceThread.ProcessRequests(True);

  Timer1.Enabled := False;
end;

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
begin
   // ShowMessage('>>> teste');
   // ShellExecute(0, 'open', 'C:\NovaOS\AtualizaOS.exe', nil, nil, SW_SHOWNORMAL);
   WinExec(PAnsiChar('C:\NovaOS\AtualizaOS.exe'),SW_SHOWNORMAL)  ;
   //ShellExecute(0,nil,pchar('C:\NovaOS\AtualizaOS.exe'),nil,nil,SW_SHOWMAXIMIZED)
end;

procedure TService1.Timer1Timer(Sender: TObject);
const
  ProgramName = 'C:\myTestproject1.exe';
var
  hToken: THandle;
//  StartupInfo: Windows.TStartupInfo;
//  ProcessInfo: Windows.TProcessInformation;
  res: boolean;
begin
//  Windows.GetStartupInfo(StartupInfo);
//  if WTSQueryUserToken(WtsGetActiveConsoleSessionID, hToken) then
//  begin
//    res := Windows.CreateProcessAsUser(hToken, ProgramName, nil, nil, nil, False, CREATE_NEW_CONSOLE, nil, nil, StartupInfo, ProcessInfo);
//    if res then
//      WaitForSingleObject(ProcessInfo.hProcess,INFINITE);
//  end;

ShowMessage(DateTimeToStr(Now));
end;

end.
