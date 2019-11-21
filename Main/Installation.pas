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
  Cancel: boolean;
  Arq: TextFile;
  CdBin: string;
  DllFolder: string;
begin
  if TDirectory.Exists(Configs.Path) then
  begin
    if TDirectory.Exists(Configs.PathFb) then
    begin
      if TDialogs.YesNo(
      'A pasta de instala��o "' + Configs.PathFb + '" j� existe, deseja sobreescrev�-la?') = mrYes then
      begin
        TDirectory.Delete(Configs.PathFb, true);
      end;
    end;
  end
  else
  begin
    TDirectory.CreateDirectory(Configs.Path);
  end;

  if TDirectory.Exists(Configs.PathFb) then
  begin
    ShowMessage('Erro na pasta de intala��o, verifique se a '+
    'vers�o do Firebird que voc� est� tentando instalar j� '+
    'est� instalada, ou se a pasta de instala��o est� em uso!');
  end
  else
  begin
    TDirectory.Copy(Configs.Source, Configs.PathFb);

    TUtils.DeleteIfExistsFile(Configs.PathConf);

    AssignFile(Arq, Configs.PathConf);

    Rewrite(Arq);

    try
      Writeln(Arq, 'RemoteServicePort = ' + Configs.Port);
    finally
      CloseFile(Arq);
    end;

    CdBin := 'cd ' + Configs.PathBin;

    TUtils.ExecDos(CdBin + ' && instreg r');
    TUtils.ExecDos(CdBin + ' && instsvc i -a -g -n ' + Configs.ServiceName);
    TUtils.ExecDos(CdBin + ' && instsvc start -n ' + Configs.ServiceName);

    for DllFolder in Configs.DllPaths do
    begin
      TUtils.DeleteIfExistsFile(DllFolder + '\fbclient.dll');
      TFile.Copy(Configs.SourceBin + '\fbclient.dll', DllFolder + '\fbclient.dll');
    end;

    ShowMessage('Instala��o Conclu�da!');
  end;
end;

procedure TInstallation.Uninstall;
var
  CdBin: string;
  DllFolder: string;
begin
  if DirectoryExists(Configs.PathFb) then
  begin
    if DirectoryExists(Configs.PathBin) then
    begin
      if not FileExists(Configs.PathBin + '\instsvc.exe') then
        TFile.Copy(Configs.SourceBin + '\instsvc.exe', Configs.PathBin + '\instsvc.exe');
      if not FileExists(Configs.PathBin + '\instreg.exe') then
        TFile.Copy(Configs.SourceBin + '\instreg.exe', Configs.PathBin + '\instreg.exe');

      CdBin := 'cd ' + Configs.PathBin;

      TUtils.ExecDos(CdBin + ' && instsvc stop -n ' + Configs.ServiceName);
      TUtils.ExecDos(CdBin + ' && instsvc r -n ' + Configs.ServiceName);
      TUtils.ExecDos(CdBin + ' && instreg r');
    end;

    TDirectory.Delete(Configs.PathFb, true);

    if DirectoryExists(Configs.PathFb) then
    begin
      ShowMessage('Erro ao desinstalar, verifique se o '+
      'nome do servi�o � o referente ao da pasta de '+
      'instala��o, ou se a pasta de instala��o est� em uso!');
    end
    else
    begin

      for DllFolder in Configs.DllPaths do
      begin
        TUtils.DeleteIfExistsFile(DllFolder + '\fbclient.dll');
      end;

      ShowMessage('Desinstala��o Conclu�da');
    end;
  end
  else
  begin
    ShowMessage('Erro ao desinstalar, esta vers�o n�o est� '+
    'instalada nesta pasta!');
  end;
end;

end.