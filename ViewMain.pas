unit ViewMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList;

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
    procedure ActPathExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WindowMain: TWindowMain;

implementation

{$R *.dfm}

procedure TWindowMain.ActPathExecute(Sender: TObject);
begin
  if OpenFilePath.Execute then
  begin
    TxtPath.Text := OpenFilePath.FileName;
  end;
end;

end.