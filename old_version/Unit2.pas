unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,inifiles;

type
  TInicioForm = class(TForm)
    EditNome: TEdit;
    LabelNome: TLabel;
    BtnOK: TButton;
    BtnCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure EditNomeChange(Sender: TObject);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InicioForm: TInicioForm;

implementation

{$R *.dfm}

uses Main;

procedure TInicioForm.FormCreate(Sender: TObject);
begin
  EditNome.Focused;
end;

procedure TInicioForm.EditNomeChange(Sender: TObject);
begin
  if Length(EditNome.Text) > 2 then
    BtnOK.Enabled := true
  else
    BtnOK.Enabled := false;
end;

procedure TInicioForm.BtnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TInicioForm.BtnOKClick(Sender: TObject);
var
  qtdUsuario : Integer;
  Ini : TIniFile;
begin
  EditNome.Text := UpperCase(EditNome.Text);
  ini := TIniFile.Create( Form1.arqConfiguracao );
  try
    qtdUsuario := Ini.ReadInteger( 'Usuario', 'quantidade', 0 );
    qtdUsuario := qtdUsuario + 1;
    ini.WriteString('Usuario', 'nome-'+IntToStr(qtdUsuario), IntToStr(qtdUsuario) + '-'+UpperCase(EditNome.Text));
    ini.WriteInteger('Usuario', 'quantidade', qtdUsuario);
  finally
    ini.Free;
  end;  
  Close;
end;

end.
