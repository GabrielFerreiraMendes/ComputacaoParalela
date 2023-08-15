unit uInformacaoEmprego;

interface

uses
  System.SysUtils, classes, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  {Modelo/abstração da tabela 'SalaryInfo' para persistência no banco de dados }
  TModelo_InformacaoEmprego = class(TObject)
  private
    FRating: double;
    FCompany_Name: String;
    FJob_Title: String;
    FSalary: Currency;
    FSalaries_Reported: Integer;
    FLocation: String;
    FConexao: TFDConnection;
    public
      constructor Create; Overload;
      procedure ProcessarDados();
    published
      property Rating             : double    read FRating            write FRating;
      property Company_Name       : String    read FCompany_Name      write FCompany_Name;
      property Job_Title          : String    read FJob_Title         write FJob_Title;
      property Salary             : Currency  read FSalary            write FSalary;
      property Salaries_Reported  : Integer   read FSalaries_Reported write FSalaries_Reported;
      property Location           : String    read FLocation          write FLocation;
  end;

type
  { Classe/camada para criação, manipulação e manutenção da base e do modelo "Informação Emprego" }
  TInformacaoEmprego = class
    public
      class procedure Clear(vConexao: TFDConnection);
      class function Create(pDados: String; vConexao: TFDConnection): TModelo_InformacaoEmprego;
  end;

implementation

{ TModelo_InformacaoEmprego }

constructor TModelo_InformacaoEmprego.Create;
begin
  inherited;
end;

procedure TModelo_InformacaoEmprego.ProcessarDados;
var
  vQry : TFDQuery;
begin
  vQry := TFDQuery.Create(nil);

  try
   vQry.Connection := Self.FConexao;

   vQry.Close;
   vQry.SQL.Clear;
   vQry.SQL.Add('INSERT INTO "Parallel_Programming"."SalaryInfo"("COMPANY_RATING",    ');
   vQry.SQL.Add('                                                "COMPANY_NAME",      ');
   vQry.SQL.Add('                                                "JOB_TITLE",         ');
   vQry.SQL.Add('                                                "SALARY",            ');
   vQry.SQL.Add('                                                "SALARIES_REPORTED", ');
   vQry.SQL.Add('                                                "LOCATION")          ');
   vQry.SQL.Add('                                        VALUES (:COMPANY_RATING,     ');
   vQry.SQL.Add('                                                :COMPANY_NAME,       ');
   vQry.SQL.Add('                                                :JOB_TITLE,          ');
   vQry.SQL.Add('                                                :SALARY,             ');
   vQry.SQL.Add('                                                :SALARIES_REPORTED,  ');
   vQry.SQL.Add('                                                :LOCATION)           ');
   vQry.ParamByName('COMPANY_RATING').AsFloat       := Self.FRating;
   vQry.ParamByName('COMPANY_NAME').AsString        := Self.FCompany_Name;
   vQry.ParamByName('JOB_TITLE').AsString           := Self.FJob_Title;
   vQry.ParamByName('SALARY').AsCurrency            := Self.FSalary;
   vQry.ParamByName('SALARIES_REPORTED').AsInteger  := Self.FSalaries_Reported;
   vQry.ParamByName('LOCATION').AsString            := Self.FLocation;
   vQry.ExecSQL;

  finally
   vQry.Close;
   vQry.Free;
  end;
end;

{ TInformacaoEmprego }

class procedure TInformacaoEmprego.Clear(vConexao: TFDConnection);
var
  vQry : TFDQuery;
begin
  vQry := TFDQuery.Create(nil);

  try
   vQry.Connection := vConexao;

   vQry.Close;
   vQry.SQL.Clear;
   vQry.SQL.Add('DELETE FROM "Parallel_Programming"."SalaryInfo";');
   vQry.ExecSQL;
  finally
   vQry.Close;
   vQry.Free;
  end;
end;

class function TInformacaoEmprego.Create(pDados: String; vConexao: TFDConnection): TModelo_InformacaoEmprego;
var
 vStl: TStringList;
begin
  Result := TModelo_InformacaoEmprego.Create;
  vStl   := TStringList.Create;


  try
   vStl.Delimiter     := ',';
   vStl.DelimitedText := StringReplace(pDados, ' ', '_', [rfReplaceAll]);

   Result.FConexao := vConexao;

   Result.Rating            := StrToCurr(StringReplace(vStl[0], '.', ',',[]));
   Result.Company_Name      := vStl[1];
   Result.Job_Title         := vStl[2];
   Result.Salary            := StrToCurr(vStl[3]);
   Result.Salaries_Reported := StrToInt(vStl[4]);
   Result.Location          := vStl[5];
  finally
   vStl.Free;
  end;
end;

end.
