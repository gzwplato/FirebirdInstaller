unit Installation;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, Vcl.Dialogs, Vcl.Controls, IniFiles,
  IOUtils, ShellApi, Windows,
  MySets, MyUtils, MyDialogs, Bean;

type
  TInstallation = class
  private
    Configs: TInstallConfigs;
  public
    constructor Create(Configs: TInstallConfigs);
    procedure Install;
    procedure Uninstall;
  end;

implementation

{ TController }

constructor TInstallation.Create(Configs: TInstallConfigs);
begin
  self.Configs := Configs;
end;

procedure TInstallation.Install;
var
  Error: string;
  Arq: TextFile;
begin
  if TDirectory.Exists(Configs.Path) then
  begin
    if TDirectory.Exists(Configs.PathFb) then
    begin
      TDirectory.Delete(Configs.PathFb, true);
    end;
  end
  else
  begin
    TDirectory.CreateDirectory(Configs.Path);
  end;

  if TDirectory.Exists(Configs.PathFb) then
  begin
    ShowMessage('Erro na pasta de intala��o!');
  end
  else
  begin
    TDirectory.Copy(Configs.Source, Configs.PathFb);

    if FileExists(Configs.PathConf) then
    begin
      TFile.Delete(Configs.PathConf);
    end;

    AssignFile(Arq, Configs.PathConf);

    try
      Writeln(Arq, 'RemoteServicePort = ' + Configs.Port);
    finally
      CloseFile(Arq);
    end;

  end;
end;

procedure TInstallation.Uninstall;
begin

end;

end.
