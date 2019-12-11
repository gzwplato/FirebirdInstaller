unit Installation;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, Vcl.Dialogs, Vcl.Controls, IniFiles,
  IOUtils, ShellApi, Windows,
  MySets, MyUtils, MyDialogs, InstallConfigs;

type
  TInstallation = class
  private
    Configs: TInstallConfigs;
  public
    constructor Create(Configs: TInstallConfigs);
    procedure CopyDll;
    procedure DeleteDll;
    procedure Install;
    procedure Uninstall;
  end;

implementation

{ TController }

constructor TInstallation.Create(Configs: TInstallConfigs);
begin
  self.Configs := Configs;
end;

procedure TInstallation.CopyDll;
var
  DllFolder: string;
begin
  for DllFolder in Configs.DllPaths do
  begin
    TUtils.DeleteIfExistsFile(DllFolder + '\fbclient.dll');
    TFile.Copy(Configs.SourceDll, DllFolder + '\fbclient.dll');
  end;
end;

procedure TInstallation.DeleteDll;
var
  DllFolder: string;
begin
  for DllFolder in Configs.DllPaths do
  begin
    TUtils.DeleteIfExistsFile(DllFolder + '\fbclient.dll');
  end;
end;

procedure TInstallation.Install;
var
  Cancel: boolean;
  Arq: TStringList;
  CdBin: string;
begin
  if TDirectory.Exists(Configs.Path) then
  begin
    if TDialogs.YesNo('A pasta de instala��o "' + Configs.Path + '" j� existe, deseja sobreescrev�-la?') = mrYes then
    begin
      TDirectory.Delete(Configs.Path, true);
    end;
  end;

  if TDirectory.Exists(Configs.Path) then
  begin
    ShowMessage('Erro na pasta de instala��o, verifique se a '+
    'vers�o do Firebird que voc� est� tentando instalar j� '+
    'est� instalada, ou se a pasta de instala��o est� em uso!');
  end
  else
  begin
    TDirectory.Copy(Configs.Source, Configs.Path);

    Arq := TStringList.Create;

    Arq.LoadFromFile(Configs.PathConf);

    Arq.Insert(0, 'RemoteServicePort = ' + Configs.Port);

    Arq.SaveToFile(Configs.PathConf);

    CdBin := 'cd ' + Configs.PathBin;

    TUtils.ExecDos(CdBin + ' && instreg r');
    TUtils.ExecDos(CdBin + ' && instsvc i -a -g -n ' + Configs.ServiceName);
    TUtils.ExecDos(CdBin + ' && instsvc start -n ' + Configs.ServiceName);

    CopyDll;

    TUtils.AddFirewallPort('Firebird ' + Configs.ServiceName, Configs.Port);

    ShowMessage('Instala��o Conclu�da!');
  end;
end;

procedure TInstallation.Uninstall;
var
  CdBin: string;
begin
  if DirectoryExists(Configs.Path) then
  begin
    if DirectoryExists(Configs.PathBin) then
    begin
      if not FileExists(Configs.PathBin + '\instsvc.exe') then
        TFile.Copy(Configs.SourceBin(true) + '\instsvc.exe', Configs.PathBin + '\instsvc.exe');
      if not FileExists(Configs.PathBin + '\instreg.exe') then
        TFile.Copy(Configs.SourceBin + '\instreg.exe', Configs.PathBin + '\instreg.exe');

      CdBin := 'cd ' + Configs.PathBin;

      TUtils.ExecDos(CdBin + ' && instsvc stop -n ' + Configs.ServiceName);
      TUtils.ExecDos(CdBin + ' && instsvc r -n ' + Configs.ServiceName);
      TUtils.ExecDos(CdBin + ' && instreg r');
    end;

    TDirectory.Delete(Configs.Path, true);

    if DirectoryExists(Configs.Path) then
    begin
      ShowMessage('Erro ao desinstalar, verifique se o '+
      'nome do servi�o � o referente ao da pasta de '+
      'instala��o, ou se a pasta de instala��o est� em uso!');
    end
    else
    begin
      DeleteDll;

      TUtils.DeleteFirewallPort('Firebird ' + Configs.ServiceName, Configs.Port);

      ShowMessage('Desinstala��o Conclu�da');
    end;
  end
  else
  begin
    ShowMessage('Erro ao desinstalar, diret�rio inexistente!');
  end;
end;

end.
