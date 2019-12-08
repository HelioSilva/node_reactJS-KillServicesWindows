unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  Vcl.ExtCtrls, MyORM.Collections, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client ,JclSvcCtrl, WinSvc,
   System.JSON, uControllerIniFile ;

type
  TService1 = class(TService)
    Timer1: TTimer;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  Service1: TService1;
  globalCNPJ : String = '' ;

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

procedure TService1.ServiceStart(Sender: TService; var Started: Boolean);
var iniFile: TIniOptions ;
begin

    iniFile := TIniOptions.Create ;
    iniFile.LoadFromFile('C:\Bin\config.ini');

    globalCNPJ := iniFile.GeralCNPJ ;
    Timer1.Enabled := true ;

    iniFile.SaveToFile('C:\Bin\config.ini');

end;

procedure TService1.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
    LogMessage(' -> serviço parado');
    Timer1.Enabled := false ;
end;

procedure TService1.Timer1Timer(Sender: TObject);
var
  JSonValue : TJSonValue;
begin
  try

    RESTClient1.BaseURL := 'http://heliosilva.online:7000/consulta/'+globalCNPJ  ;
    RESTRequest1.Execute ;
    JsonValue := TJSonObject.ParseJSONValue(RESTResponse1.Content);

    if JsonValue.GetValue<string>('ativo') = 'false' then
        StopServiceByName('','FirebirdGuardianDefaultInstance')
    else
        StartServiceByName('','FirebirdGuardianDefaultInstance')  ;
    //LogMessage(JsonValue.GetValue<string>('ativo'));

  except
    On E: Exception do
    begin
     // LogMessage(' -> erro de conexão com o banco de dados!');
    end;

  end;

end;

end.
