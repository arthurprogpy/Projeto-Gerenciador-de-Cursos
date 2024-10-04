
unit unit_rel_turmas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, StdCtrls, Buttons, DB, ADODB;

type
  TForm_rel_turmas = class(TForm)
    edt_curso: TEdit;
    Label1: TLabel;
    adoquery_rel_turmas: TADOQuery;
    adoquery_aux: TADOQuery;
    btn_ok: TBitBtn;
    btn_fechar: TBitBtn;
    btn_curso: TBitBtn;
    rel_turmas: TRvProject;
    ds_rel_turmas: TRvDataSetConnection;
    adoquery_rel_turmasCURSO: TStringField;
    adoquery_rel_turmasTURMA: TStringField;
    adoquery_rel_turmasINTRUTORES: TStringField;
    procedure FormShow(Sender: TObject);
    procedure btn_cursoClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cod_curso: string;
  end;

var
  Form_rel_turmas: TForm_rel_turmas;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

procedure TForm_rel_turmas.FormShow(Sender: TObject);
begin
  cod_curso := '';
  edt_curso.Clear;
end;

procedure TForm_rel_turmas.btn_cursoClick(Sender: TObject);
begin
  edt_curso.clear;
  cod_curso := '';
  sql_pesquisa := 'SELECT * FROM CURSOS';
  form_pesquisa.ShowModal;

  if chave <> '' then
    begin
      cod_curso := chave;
      adoquery_aux.sql.Text := 'SELECT NOME FROM CURSOS '+
                                ' WHERE COD_CURSO = ' + QuotedStr(cod_curso);
      adoquery_aux.open;
      edt_curso.text := adoquery_aux.fieldbyname('NOME').AsString;
    end;
end;

procedure TForm_rel_turmas.btn_okClick(Sender: TObject);
var
sql : String;
begin
  if cod_curso = '' then
    begin
      ShowMessage('Selecione um curso!');
    end
  else
    begin
      sql := ' SELECT CURSOS.NOME AS CURSO, ' +
              '       TURMAS.COD_TURMA AS TURMA, '+
              '       INSTRUTORES.NOME AS INTRUTORES '+
              ' FROM TURMAS '+
              ' INNER JOIN CURSOS  '+
              ' ON TURMAS.COD_CURSO = CURSOS.COD_CURSO '+
              ' INNER JOIN INSTRUTORES '+
              ' ON TURMAS.COD_INSTRUTOR = INSTRUTORES.COD_INSTRUTOR '+
              ' WHERE TURMAS.COD_CURSO = '+ QuotedStr(cod_curso ) +
              ' ORDER BY TURMAS.COD_TURMA ';

              
      adoquery_rel_turmas.SQL.text := sql;
      adoquery_rel_turmas.Open;
      if adoquery_rel_turmas.IsEmpty then
        begin
          ShowMessage('Não existe nenhuma turma neste curso !');
        end
      else
        begin
          rel_turmas.ProjectFile := GetCurrentDir + '\rel_turmas.rav';
          rel_turmas.Execute;
        end;

      adoquery_rel_turmas.Close;
    end;
end;

procedure TForm_rel_turmas.btn_fecharClick(Sender: TObject);
begin
  close;
end;

end.
