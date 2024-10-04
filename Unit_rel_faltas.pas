unit Unit_rel_faltas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, DB, ADODB, StdCtrls, Buttons;

type
  TForm_rel_faltas = class(TForm)
    Label1: TLabel;
    edt_turma: TEdit;
    btn_turma: TBitBtn;
    btn_ok: TBitBtn;
    btn_fechar: TBitBtn;
    adoquery_rel_faltas: TADOQuery;
    adoquery_aux: TADOQuery;
    rel_faltas: TRvProject;
    ds_rel_faltas: TRvDataSetConnection;
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_turmaClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cod_turma: String;
  end;

var
  Form_rel_faltas: TForm_rel_faltas;

implementation

uses Unit_Logon, Unit_Pesquisa_Turma, Unit_ConexaoDB;

{$R *.dfm}

procedure TForm_rel_faltas.FormShow(Sender: TObject);
begin
  cod_turma := '';
  edt_turma.clear;
end;

procedure TForm_rel_faltas.btn_okClick(Sender: TObject);
var sql: string;
begin
  if cod_turma = '' then
    begin
      ShowMessage('Selecione uma Turma');
    end
  else
    begin
      sql := ' SELECT TURMAS.COD_TURMA AS TURMA, '+
              '		ALUNOS.COD_ALUNO,'+
              '		ALUNOS.NOME,'+
              '		SUM(CASE WHEN FREQUENCIAS.PRESENTE = '+ QuotedStr('N')  +
              '				 THEN 1 ELSE 0 END) AS FALTAS '+
              ' FROM TURMAS '+
              ' INNER JOIN MATRICULAS '+
              '	ON TURMAS.COD_TURMA = MATRICULAS.COD_TURMA '+
              ' INNER JOIN ALUNOS '+
              '	ON MATRICULAS.COD_ALUNO = ALUNOS.COD_ALUNO '+
              ' INNER JOIN FREQUENCIAS '+
              '	ON MATRICULAS.COD_TURMA = FREQUENCIAS.COD_TURMA '+
              ' AND MATRICULAS.COD_ALUNO  = FREQUENCIAS.COD_ALUNO '+
              ' WHERE TURMAS.COD_TURMA = '+ QuotedStr(cod_turma)+
              ' GROUP BY TURMAS.COD_TURMA, ALUNOS.COD_ALUNO, ALUNOS.NOME '+
              ' ORDER BY ALUNOS.NOME';

      adoquery_rel_faltas.SQL.Text := sql;
      adoquery_rel_faltas.Open;
      if adoquery_rel_faltas.IsEmpty then
        begin
          ShowMessage('Este Instrutor não apresenta alunos !');
        end
      else
        begin
          rel_faltas.ProjectFile :=  GetCurrentDir + '\rel_faltas.rav';
          rel_faltas.Execute;
        end;

      adoquery_rel_faltas.Close;

    end;
end;

procedure TForm_rel_faltas.btn_turmaClick(Sender: TObject);
begin
   edt_turma.clear;
   cod_turma := '';
   form_pesquisa_turmas.ShowModal;

   if form_pesquisa_turmas.chave <> '' then
    begin
      cod_turma := form_pesquisa_turmas.chave;
      edt_turma.Text := cod_turma;
    end
end;

procedure TForm_rel_faltas.btn_fecharClick(Sender: TObject);
begin
  close;
end;

end.
