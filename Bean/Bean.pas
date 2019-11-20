unit Bean;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils,
  MySets, MyUtils;

type
  TInstallConfigs = class
  private
    FVersion: TVersion;
    FPath: string;
    FServiceName: string;
    FPort: string;
    FDllPaths: System.TArray<System.string>;
    procedure SetVersion(const Value: TVersion);
    procedure SetPath(const Value: string);
    procedure SetServiceName(const Value: string);
    procedure SetPort(const Value: string);
    procedure SetDllPaths(const Value: System.TArray<System.string>);

    function FolderName: string;
  public
    property Version: TVersion read FVersion write SetVersion;
    property Path: string read FPath write SetPath;
    property ServiceName: string read FServiceName write SetServiceName;
    property Port: string read FPort write SetPort;
    property DllPaths: System.TArray<System.string> read FDllPaths write SetDllPaths;

    function PathFb: string;
    function PathBin: string;
    function PathConf: string;
    function Source: string;
  end;

implementation

{ TInstallationConfigs }

procedure TInstallConfigs.SetVersion(const Value: TVersion);
begin
  FVersion := Value;
end;

procedure TInstallConfigs.SetPath(const Value: string);
begin
  FPath := Value;
end;

procedure TInstallConfigs.SetServiceName(const Value: string);
begin
  FServiceName := Value;
end;

procedure TInstallConfigs.SetPort(const Value: string);
begin
  FPort := Value;
end;

procedure TInstallConfigs.SetDllPaths(const Value: System.TArray<System.string>);
begin
  FDllPaths := Value;
end;

//Pasta destino de instala��o
function TInstallConfigs.PathFb: string;
begin
  Result := Path + FolderName;
end;

//Pasta destino dos utilit�rios
function TInstallConfigs.PathBin: string;
begin
  case Version of
  vrFb21, vrFb25:
    Result := PathFb + '\Bin';
  vrFb30:
    Result := PathFb;
  end;
end;

//Arquivo firebird.conf
function TInstallConfigs.PathConf: string;
begin
  Result := PathFb + '\firebird.conf';
end;

//Pasta fonte do firebird
function TInstallConfigs.Source: string;
begin
  Result := TUtils.AppPath + 'Data' + FolderName;
end;

//Nome da pasta pela vers�o
function TInstallConfigs.FolderName: string;
begin
  case Version of
  vrFb21:
    Result := '\Firebird_2_1';
  vrFb25:
    Result := '\Firebird_2_5';
  vrFb30:
    Result := '\Firebird_3_0';
  end;
end;

end.
