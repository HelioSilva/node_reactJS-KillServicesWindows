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
  ComObj, ActiveX, JwaWinbase , uSysAccount, JvLogFile, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type

  TController = class
    private
      FCNPJ: string;
      FVERSAO: string;
      FINTERVAL: integer;
      procedure SetCNPJ(const Value: string);
      procedure SetINTERVAL(const Value: integer);
      procedure SetVERSAO(const Value: string);
    public
      constructor Create() ;
      property CNPJ: string  read FCNPJ write SetCNPJ;
      property INTERVAL: integer  read FINTERVAL write SetINTERVAL;
      property VERSAO: string  read FVERSAO write SetVERSAO;
      procedure saveINI();
  end;

  TService1 = class(TService)
    Timer1: TTimer;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTClient1: TRESTClient;
    JvComputerInfoEx1: TJvComputerInfoEx;
    JvLogFile1: TJvLogFile;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDQuery1: TFDQuery;
    IdHTTP1: TIdHTTP;

    procedure  ServiceStart(Sender: TService; var Started: Boolean);
    procedure  Timer1Timer(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
    procedure ServiceAfterInstall(Sender: TService);
    procedure IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
  private
    { Private declarations }
    procedure downloadFileURL ;

    procedure OnAfterInstall ; // prepare after install

    procedure Initialize ; // prepare
    procedure Running    ; // initialize loop
    procedure UpdateLoop ; // execute task

    procedure WriteLog(msg:string) ;

  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

const
  PATH = 'C:\Bin';
  PATH_INI = 'C:\Bin\config.ini';

  BASE_URL = 'http://localhost:7000/consulta/';
  SERVICO_FIREBIRD = 'FirebirdGuardianDefaultInstance';

  UPDATED_URL = 'https://bucketfaq.s3.amazonaws.com/ServiceKillAPP.exe';

var
  Service1: TService1;
  _controller : TController ;


implementation

uses
  JvLogClasses, uFunctionsUtils, JwaWinType;

{$R *.dfm}


function GetVersionInfo : String;
type
  TLang = packed record
    Lng, Page: WORD;
  end;

  TLangs = array [0 .. 10000] of TLang;
  PLangs = ^TLangs;

var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeAndNil(RS);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + 'FileVersion' ;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      Exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeAndNil(RM);
  end;
end;

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

procedure TService1.downloadFileURL;
var
  Stream: TMemoryStream;
  Url, FileName: String;
begin
  if FileExists(PATH + 'backup.exe') then
      DeleteFile(PATH + 'backup.exe');

  Url := UPDATED_URL ;
  Filename := PATH+'/updated.exe';

  Stream := TMemoryStream.Create;
  try
    try
      IdHTTP1.Get(Url, Stream);
      Stream.SaveToFile(FileName);

      RenameFile(PATH+'/serviceUI.exe' , PATH+'/backup.exe') ;
      RenameFile(PATH+'/updated.exe', PATH+'/serviceUI.exe') ;
      WriteLog('Executaveis atualizados com sucesso');

      Controller(SERVICE_CONTROL_STOP);
      Controller(SERVICE_CONTROL_CONTINUE);

    except on E: Exception do
       WriteLog('Falha ao baixar atualização');
    end;
  finally
    Stream.Free;
  end;
end;



function TService1.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService1.IdHTTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
var
  Http: TIdHTTP;
  ContentLength: Int64;
  Percent: Integer;
begin
  Http := TIdHTTP(ASender);
  ContentLength := Http.Response.ContentLength;

  if (Pos('chunked', LowerCase(Http.Response.TransferEncoding)) = 0) and
     (ContentLength > 0) then
  begin
    Percent := 100*AWorkCount div ContentLength;

    WriteLog(IntToStr(Percent)+' %');
  end;
end;

procedure TService1.Initialize;
begin

  JvLogFile1.FileName := PATH+'\logService.txt' ;

  JvLogFile1.Active := true ;

  WriteLog(' Initialized!');
  WriteLog(' -- Versão: '+GetVersionInfo+' -- ');

  if not DirectoryExists(PATH) then
    if not CreateDir(PATH) then
      WriteLog('Cannot create diretory: >> '+PATH+' << ');

  _controller := TController.Create ;
  _controller.saveINI ;

end;

procedure TService1.OnAfterInstall;
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

procedure TService1.Running;
begin
  Timer1.Interval := _controller.INTERVAL * 1000 ;
  Timer1.Enabled := true ;
  WriteLog(' Service loop started');
end;

procedure TService1.ServiceAfterInstall(Sender: TService);
begin
 OnAfterInstall;
end;

procedure TService1.ServiceExecute(Sender: TService);
begin

  while not Terminated do
    ServiceThread.ProcessRequests(True); // wait for termination

end;

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
begin
  Initialize ;
  Running;
end;

procedure TService1.Timer1Timer(Sender: TObject);
begin
  UpdateLoop ;
end;

procedure TService1.UpdateLoop;
var
  JSonValue : TJSonValue;
   jsonObject : TJSONObject;
  content : String ;
  statusService : TJclServiceState ;
begin

  WriteLog(' -- Debug -- ');

  if _controller.CNPJ = '' then
  begin
    WriteLog(' CNPJ não configurado!!!!');
    abort ;
  end;

  try

    // Captura o status do serviço
    statusService := GetServiceStatusByName('',SERVICO_FIREBIRD) ;
    case statusService of
      ssUnknown:          WriteLog('Service status: Desconhecido');
      ssStopped:          WriteLog('Service status: Parado');
      ssStartPending:     WriteLog('Service status: Pendente');
      ssStopPending:      WriteLog('Service status: Parando');
      ssRunning:          WriteLog('Service status: Em execução');
      ssContinuePending:  WriteLog('Service status: Reestabelecendo');
      ssPausePending:     WriteLog('Service status: Desligando');
      ssPaused:           WriteLog('Service status: Pausado');
    end;


    jsonObject := TJSONObject.Create;

    RESTClient1.BaseURL := BASE_URL+_controller.CNPJ  ;

    jsonObject.AddPair('versao',GetVersionInfo);
    jsonObject.AddPair('memoria',JvComputerInfoEx1.Memory.MemoryLoad.ToString) ;
    jsonObject.AddPair('nomeCPU',JvComputerInfoEx1.Identification.LocalComputerName) ;
    jsonObject.AddPair('ip',JvComputerInfoEx1.Identification.IPAddress) ;

    RESTRequest1.AddBody(jsonObject);
    RESTRequest1.Execute ;
    JsonValue := TJSonObject.ParseJSONValue(RESTResponse1.Content,true);

    WriteLog( RESTResponse1.Content );


    // Verificando as versões
    if String(JSonValue.GetValue<string>('versao')) <> GetVersionInfo then
    begin
      WriteLog('Versão desatualizada');
      downloadFileURL ;
    end;

    // Verificando o intervalo de loop
    if StrToIntDef(JSonValue.GetValue<string>('interval'),60) <> _controller.INTERVAL then
    begin
      _controller.INTERVAL := StrToIntDef(JSonValue.GetValue<string>('interval'),60) ;
      _controller.saveINI ;
    end;



    if JsonValue.GetValue<String>('ativo') = 'false' then
    begin
      if statusService = ssRunning then
      begin
        StopServiceByName( '',SERVICO_FIREBIRD)  ;
        WriteLog('Parando o serviço FIREBIRD');
      end;
    end
    else
    begin
      if statusService = ssStopped then
      begin
        StartServiceByName( '',SERVICO_FIREBIRD)  ;
        WriteLog('Iniciando o serviço FIREBIRD');
      end;
    end;

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


{ TController }

constructor TController.Create();
var iniFile: TIniOptions ;
begin

    iniFile := TIniOptions.Create ;
    iniFile.LoadFromFile(PATH_INI);

    self.CNPJ := iniFile.GeralCNPJ ;
    self.VERSAO := iniFile.GeralVERSAO ;
    self.INTERVAL := iniFile.GeralINTERVAL ;

end;

procedure TController.saveINI;
var iniFile: TIniOptions ;
begin
    iniFile := TIniOptions.Create ;
    iniFile.GeralCNPJ := CNPJ ;
    iniFile.GeralVERSAO := VERSAO ;
    iniFile.GeralINTERVAL := INTERVAL ;
    iniFile.SaveToFile(PATH_INI);
end;

procedure TController.SetCNPJ(const Value: string);
begin
  FCNPJ := Value;
end;

procedure TController.SetINTERVAL(const Value: integer);
begin
  FINTERVAL := Value;
end;

procedure TController.SetVERSAO(const Value: string);
begin
  FVERSAO := Value;
end;

end.
