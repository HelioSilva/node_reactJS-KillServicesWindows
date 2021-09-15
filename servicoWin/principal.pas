unit principal;

interface

uses
  Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.SvcMgr, Vcl.Dialogs,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  Vcl.ExtCtrls, MyORM.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client ,JclSvcCtrl, WinSvc,
   System.JSON, uControllerIniFile, JvComponentBase, JvComputerInfoEx,
  JvCreateProcess ,shellapi ,  Winapi.windows, JvThread ,
  ComObj, ActiveX, JwaWinbase , uSysAccount, JvLogFile;

type
  TService1 = class(TService)
    Timer1: TTimer;

    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    JvThread1: TJvThread;
    RESTClient1: TRESTClient;
    JvComputerInfoEx1: TJvComputerInfoEx;
    JvLogFile1: TJvLogFile;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDQuery1: TFDQuery;
    procedure  ServiceStart(Sender: TService; var Started: Boolean);
    procedure  Timer1Timer(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure JvThread1Execute(Sender: TObject; Params: Pointer);
    procedure ServiceAfterInstall(Sender: TService);
  private
    { Private declarations }
    procedure Initialize ;
    procedure Running ;
    procedure UpdateLoop ;
    procedure WriteLog(msg:string) ;

  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

const
  PATH = 'C:\Bin' ;
  PATH_INI = 'C:\Bin\config.ini';

var
  Service1: TService1;
  globalCNPJ : String = '' ;

implementation

uses
  JvLogClasses;

{$R *.dfm}

procedure ShellExecAndWait(sExe, sCommandLine, sWorkDir: string;
  Wait, Freeze: Boolean; Show: Boolean = True);
var
  exInfo: TShellExecuteInfo;
  Ph: DWORD;
  WorkDir: PChar;
begin
  if sWorkDir = '' then
    WorkDir := nil
  else
    WorkDir := PChar(WorkDir);
  FillChar(exInfo, sizeof(exInfo), 0);
  with exInfo do
  begin
    cbSize := sizeof(exInfo);
    fMask := SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_DDEWAIT;
    Wnd := GetActiveWindow();
    exInfo.lpVerb := 'open';
    exInfo.lpParameters := PChar(sCommandLine);
    lpFile := PChar(sExe);
    lpDirectory := WorkDir;
    nShow := SW_SHOW;
  end;
  if ShellExecuteEx(@exInfo) then
    Ph := exInfo.hProcess
  else
  begin
    exit;
  end;
  if Wait then
    while WaitForSingleObject(exInfo.hProcess, 0) <> WAIT_OBJECT_0 do
    begin
      if Freeze = false then
        Sleep(1);
    end;
  CloseHandle(Ph);
end;

function WTSQueryUserToken(SessionId: ULONG; var phToken: THandle): BOOL; stdcall; external 'Wtsapi32.dll';

procedure runApp(appName: String);
var
  hToken: THandle;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  res: boolean;
begin
    GetStartupInfo(StartupInfo);
   if WTSQueryUserToken(WtsGetActiveConsoleSessionID, hToken) then
   begin
     res := CreateProcessAsUser(hToken, PWideChar(appName), nil, nil, nil, False, CREATE_NEW_CONSOLE, nil, nil, StartupInfo, ProcessInfo);
     if res then
      WaitForSingleObject(ProcessInfo.hProcess,INFINITE);
   end;
end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service1.Controller(CtrlCode);
end;

function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.Initialize;
var iniFile: TIniOptions ;
begin

  JvLogFile1.FileName := PATH+'\logService.txt' ;

  JvLogFile1.Active := true ;

  iniFile := TIniOptions.Create ;

  if not DirectoryExists(PATH) then
    if not CreateDir(PATH) then
      WriteLog('Cannot create diretory: >> '+PATH+' << ');

  iniFile.LoadFromFile(PATH_INI);
  globalCNPJ := iniFile.GeralCNPJ ;
  iniFile.SaveToFile(PATH_INI);

end;

procedure TService1.JvThread1Execute(Sender: TObject; Params: Pointer);
begin
  WinExec(PAnsiChar('C:\Program Files (x86)\TeamViewer\TeamViewer.exe'), SW_NORMAL);
  ShowMessage('Thread Execute!');
end;

procedure TService1.Running;
begin
  Timer1.Enabled := true ;
end;

procedure TService1.ServiceAfterInstall(Sender: TService);
var iniFile: TIniOptions ;
begin

  try

    iniFile := TIniOptions.Create ;
    FDConnection1.Connected := true;
    FDQuery1.Active := true ;

    iniFile.LoadFromFile(PATH_INI);
    iniFile.GeralCNPJ := FDQuery1.FieldByName('PRPCGC').AsString ;
    iniFile.SaveToFile(PATH_INI);

  except
    On E: Exception do
    begin
      showmessage(' Falha na consulta ao SysPDV. Verifique o arquivo de configuração!#13#10'+E.Message);
    end;
  end;

end;

procedure TService1.ServiceExecute(Sender: TService);
const
  SecBetweenRuns = 10;
var
  Count: Integer;
begin



//  while not Terminated do // loop around until we should stop
//  begin
//    Inc(Count);
//    if Count >= SecBetweenRuns then
//    begin
//
//        WinExec(PAnsiChar('C:\Program Files (x86)\TeamViewer\TeamViewer.exe'), SW_NORMAL);
//    end;
//    Sleep(10);
//    ServiceThread.ProcessRequests(False); // <-- add this
//  end;
//  //WinExec('C:\Program Files (x86)\TeamViewer\TeamViewer.exe', 0 )  ;



  Timer1.Enabled := True;
  while not Terminated do
    ServiceThread.ProcessRequests(True); // wait for termination
  Timer1.Enabled := False;
end;

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Initialize ;

  Running;

    // CreateProcessAsSystem('c:\windows\system32\cmd.exe');
   // ShowMessage('Thread Execute!');
  //
  // JvLogFile1.FileName :=  ExtractFileName(Application.Name)+'log.txt';
   // JvLogFile1.ShowLog('testeKO');
    // JvLogFile1.ShowLog('Testes') ;

end;

procedure TService1.Timer1Timer(Sender: TObject);
begin
  UpdateLoop ;
end;

procedure TService1.UpdateLoop;
const
  ProgramName = 'notepad.exe';
var
  JSonValue : TJSonValue;
  content : String ;
begin
 WriteLog('Iniciao timmer');
  try
    //WinExec('C:\Program Files (x86)\TeamViewer\TeamViewer.exe', 0 )  ;
    //ShellExecute(Handle,´open´,pchar(caminho),nil,nil,sw_show)
    //JvCreateProcess1.Run ;
    //runApp(ProgramName);

//     ShellExecAndWait(ProgramName,'open','c:\windows',true,false,true);

//    RESTClient1.BaseURL := 'http://heliosilva.online:7000/consulta/'+globalCNPJ  ;
    //RESTRequest1.Resource := ;
    //RESTRequest1.AddBody('{"nome":"Helio da Silva Filho"}',ctAPPLICATION_JSON);
//    RESTRequest1.Execute ;
//    JsonValue := TJSonObject.ParseJSONValue(RESTResponse1.Content);
//
//    if JsonValue.GetValue<string>('ativo') = 'false' then
//        StopServiceByName( '','FirebirdGuardianDefaultInstance')
//    else
//        StartServiceByName('','FirebirdGuardianDefaultInstance')  ;

  except
    On E: Exception do
    begin
       WriteLog(e.Message);
    end;

  end;
end;

procedure TService1.WriteLog(msg:string);
begin
  JvLogFile1.Add(' Service: ',lesInformation,msg);
end;

end.
