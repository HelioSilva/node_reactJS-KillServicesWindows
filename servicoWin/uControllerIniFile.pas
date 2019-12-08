unit uControllerIniFile;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const

  csIniConexaoSection = 'GERAL';



  {Section: Conexao}
  csIniGeralCNPJ = 'CNPJ';
  csIniGeralVERSAO = 'VERSAO';


type
  TIniOptions = class(TObject)
  private


    {Section: Conexao}
    FGeralCNPJ: string;
    FGeralVERSAO: string;
    procedure SetGeralCNPJ(const Value: string);
    procedure SetGeralVERSAO(const Value: string);

  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);
    
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

       {Section: Conexao}
    property GeralCNPJ: string  read FGeralCNPJ write SetGeralCNPJ;
    property GeralVERSAO : string  read FGeralVERSAO write SetGeralVERSAO;

   end;

var
  IniOptions: TIniOptions = nil;

implementation

procedure TIniOptions.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin

    {Section: Conexao}
    FGeralCNPJ := Ini.ReadString(csIniConexaoSection, csIniGeralCNPJ, '00657034000153');
    FGeralVERSAO := Ini.ReadString(csIniConexaoSection, csIniGeralVERSAO, '1.0');
  end;
end;

procedure TIniOptions.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin

    {Section: Conexao}
    Ini.WriteString(csIniConexaoSection, csIniGeralCNPJ, FGeralCNPJ);
    Ini.WriteString(csIniConexaoSection, csIniGeralVERSAO, FGeralVERSAO);
    
  end;
end;

procedure TIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TIniOptions.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

procedure TIniOptions.SetGeralCNPJ(const Value: string);
begin
  FGeralCNPJ := Value;
end;

procedure TIniOptions.SetGeralVERSAO(const Value: string);
begin
  FGeralVERSAO := Value;
end;

initialization
  IniOptions := TIniOptions.Create;

finalization
  IniOptions.Free;

end.

