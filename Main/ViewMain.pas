unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, System.ImageList, Vcl.ImgList,
  System.Actions, Vcl.ActnList, Vcl.CheckLst, Vcl.Grids,
  Sets, Bean, Controller;

type
  TWindowMain = class(TForm)
    BoxVersion: TComboBox;
    LblVersion: TLabel;
    LblPath: TLabel;
    TxtPath: TEdit;
    Actions: TActionList;
    ActPath: TAction;
    ActEsc: TAction;
    Images: TImageList;
    BtnPath: TSpeedButton;
    OpenFilePath: TFileOpenDialog;
    LblServiceName: TLabel;
    TxtServiceName: TEdit;
    LblPort: TLabel;
    TxtPort: TEdit;
    LblOptions: TLabel;
    CheckInstReg: TCheckBox;
    CheckInstGuard: TCheckBox;
    ListDll: TListBox;
    LblDll: TLabel;
    BtnAdd: TSpeedButton;
    ActAdd: TAction;
    ActRemove: TAction;
    BtnRemove: TSpeedButton;
    ActInstall: TAction;
    ActUninstall: TAction;
    BtnInstall: TSpeedButton;
    BtnUninstall: TSpeedButton;
    OpenDllPath: TFileOpenDialog;
    procedure ActPathExecute(Sender: TObject);
    procedure ActAddExecute(Sender: TObject);
    procedure ActRemoveExecute(Sender: TObject);
    procedure ActUninstallExecute(Sender: TObject);
    procedure ActInstallExecute(Sender: TObject);
  end;

var
  WindowMain: TWindowMain;

implementation

{$R *.dfm}

procedure TWindowMain.ActAddExecute(Sender: TObject);
begin
  if OpenDllPath.Execute then
  begin
    ListDll.Items.Add(OpenDllPath.FileName);
  end;
end;

procedure TWindowMain.ActRemoveExecute(Sender: TObject);
begin
  ListDll.DeleteSelected;
end;

procedure TWindowMain.ActInstallExecute(Sender: TObject);
var
  Options: TInstallationOptions;
  Configs: TInstallationConfigs;
  Controller: TController;
begin
  try
    Configs := TInstallationConfigs.Create;

    with Configs do
    begin
      Version := TVersion(BoxVersion.ItemIndex);
      Path := TxtPath.Text;
      ServiceName := TxtServiceName.Text;
      Port := TxtPort.Text;
      if CheckInstReg.Checked then Options := Options + [ioInstRegistry];
      if CheckInstGuard.Checked then Options := Options + [ioInstGuardian];
      DllPaths := ListDll.Items.ToStringArray;
    end;

    Controller := TController.Create(Configs);

    Controller.Install;
  finally
    FreeAndNil(Configs);
    FreeAndNil(Controller);
  end;
end;

procedure TWindowMain.ActUninstallExecute(Sender: TObject);
begin
  //
end;

procedure TWindowMain.ActPathExecute(Sender: TObject);
begin
  if OpenFilePath.Execute then
  begin
    TxtPath.Text := OpenFilePath.FileName;
  end;
end;

end.