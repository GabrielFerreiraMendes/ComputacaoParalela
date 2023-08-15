unit uMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Data.Win.ADODB, Data.DB,
  Data.SqlExpr, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uInformacaoEmprego,
  System.Threading, System.Diagnostics;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    bEdtArquivo: TButtonedEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure bEdtArquivoRightButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.bEdtArquivoRightButtonClick(Sender: TObject);
begin
  { Efetuando consulta do arquivo e armazenando o diret�rio }
  if OpenDialog1.Execute then
   bEdtArquivo.Text := OpenDialog1.FileName;
end;

{ Inser��o/Processamento dos dados presentes do arquivo de forma iterativa }
procedure TForm1.SpeedButton1Click(Sender: TObject);
var
 vArquivo     : TStringList;
 vCronometro  : TStopwatch;
 vIndice      : Integer;
begin
  {Objeto para contagem do tempo utilizado na inser��o/processamento }
  vCronometro := TStopWatch.Create;

  {Objeto para leitura do arquivo e informa��es a serem inseridas/processadas }
  vArquivo    := TStringList.Create;

  try
   {Iniciando a contagem do tempo }
   vCronometro.Start;

   {Efetuando a leitura (com formata��o UTF8) do arquivo para itera��o sobre ele }
   vArquivo.LoadFromFile(bEdtArquivo.Text, TEncoding.UTF8);

   {Limpando informa��es da base de dados antes da inser��o/processamento }
   TInformacaoEmprego.Clear(FDConnection1);

   { Iterando apartir da segunda linha pois na primeira existe o cabe�alho }
   for vIndice := 1 to Pred(vArquivo.Count) do
    begin
     {Utiliza��o de class methods para inser��o/processamento da "linha" }
     TInformacaoEmprego.Create(vArquivo[vIndice], FDConnection1).ProcessarDados;
    end;

   { Encerrando a contagem do tempo utilizado na inser��o/processamento}
   vCronometro.Stop;

   { Exibindo o tem tempo gasot durante toda a opera��o }
   ShowMessage(Format('Milisegundos utilizados para processamento iterativo: %s',
                      [vCronometro.ElapsedMilliseconds.ToString]));
  finally
   {Realizando a exclus�o do objeto que armazenou o arquivo.}
   FreeAndNil(vArquivo);
  end;
end;

{ Inser��o/Processamento dos dados presentes do arquivo de forma paralela }
procedure TForm1.SpeedButton2Click(Sender: TObject);
var
 vArquivo     : TStringList;
 vCronometro  : TStopwatch;
begin
  {Objeto para contagem do tempo utilizado na inser��o/processamento }
  vCronometro := TStopWatch.Create;

  {Objeto para leitura do arquivo e informa��es a serem inseridas/processadas }
  vArquivo    := TStringList.Create;

  try
   {Iniciando a contagem do tempo }
   vCronometro.Start;

   {Efetuando a leitura (com formata��o UTF8) do arquivo para itera��o sobre ele }
   vArquivo.LoadFromFile(bEdtArquivo.Text, TEncoding.UTF8);

   {Limpando informa��es da base de dados antes da inser��o/processamento }
   TInformacaoEmprego.Clear(FDConnection1);

   { Utilizando biblioteca de processamento paralelo do Delphi para iterar pelo
     arqui, inciando na segunda linha devido ao cabe�alho na primeira linha}
   TParallel.For(1, Pred(vArquivo.Count), procedure (pIndice: integer)
                                      begin
                                        { Como nesse cen�rio h� concorr�ncia de acesso ao
                                          banco de dados, se faz necess�rio o uso de um semaforo
                                          para garantir que aplica��o n�o ir� "acessar" recurso
                                          computacional indispon�vel. }
                                        TThread.Queue(TThread.CurrentThread,
                                          procedure
                                          begin
                                           {Utiliza��o de class methods para inser��o/processamento da "linha" }
                                           TInformacaoEmprego.Create(vArquivo[pIndice], FDConnection1).ProcessarDados;
                                          end)
                                      end);

   { Encerrando a contagem do tempo utilizado na inser��o/processamento}
   vCronometro.Stop;

   { Exibindo o tem tempo gasot durante toda a opera��o }
   ShowMessage(Format('Milisegundos utilizados para processamento paralelo: %s',
                      [vCronometro.ElapsedMilliseconds.ToString]));
  finally
   {Realizando a exclus�o do objeto que armazenou o arquivo.}
   FreeAndNil(vArquivo);
  end;
end;

end.
