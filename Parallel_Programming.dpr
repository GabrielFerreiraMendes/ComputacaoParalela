program Parallel_Programming;

uses
  Vcl.Forms,
  uMainForm in 'uMainForm.pas' {Form1},
  uInformacaoEmprego in 'uInformacaoEmprego.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
