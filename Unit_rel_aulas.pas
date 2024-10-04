unit Unit_rel_aulas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, DB, ADODB, StdCtrls, Buttons;

type
  TForm_rel_aulas = class(TForm)
    Label1: TLabel;
    edt_instrutor: TEdit;
    btn_instrutores: TBitBtn;
    btn_ok: TBitBtn;
    btn_fechar: TBitBtn;
    adoquery_rel_aulas: TADOQuery;
    adoquery_aux: TADOQuery;
    rel_aulas: TRvProject;
    ds_rel_aulas: TRvDataSetConnection;
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_instrutoresClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cod_instrutor : String;
  end;

var
  Form_rel_aulas: TForm_rel_aulas;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

procedure TForm_rel_aulas.FormShow(Sender: TObject);
begin
  cod_instrutor := '';
  edt_instrutor.Clear;
end;

procedure TForm_rel_aulas.btn_okClick(Sender: TObject);
var sql : String;
begin
  if cod_instrutor = '' then
    begin
      ShowMessage('Selecione um Instrutor !');
    end
  else
    begin
      sql := ' SELECT INSTRUTORES.COD_INSTRUTOR, ' +
              '       INSTRUTORES.NOME, '+
              '        TURMAS.COD_TURMA, '+
              '		COUNT(AULAS.DATA)  AS AULAS'+
              ' FROM INSTRUTORES'+
              ' INNER JOIN TURMAS'+
              '	ON INSTRUTORES.COD_INSTRUTOR = TURMAS.COD_INSTRUTOR '+
              ' INNER JOIN AULAS '+
              ' ON TURMAS.COD_TURMA = AULAS.COD_TURMA '+
              ' WHERE INSTRUTORES.COD_INSTRUTOR = ' + cod_instrutor +
              ' GROUP BY INSTRUTORES.COD_INSTRUTOR, '+
              '               INSTRUTORES.NOME, TURMAS.COD_TURMA'+
              ' ORDER BY COD_TURMA';

      adoquery_rel_aulas.sql.Text := sql;
      adoquery_rel_aulas.Open;
      if adoquery_rel_aulas.IsEmpty then
        begin
          ShowMessage('Este instrutor não apresenta aulas!')
        end
      else
        begin
          rel_aulas.ProjectFile := GetCurrentDir + '\rel_aulas.rav';
          rel_aulas.Execute;
        end;
      adoquery_rel_aulas.Close;
    end;
end;

procedure TForm_rel_aulas.btn_instrutoresClick(Sender: TObject);
begin
  edt_instrutor.Clear;
  cod_instrutor := '';
  sql_pesquisa := 'SELECT * FROM INSTRUTORES ';
  form_pesquisa.ShowModal;

  if chave <> '' then
    begin
      cod_instrutor := chave;
      adoquery_aux.SQL.Text := ' SELECT NOME FROM INSTRUTORES ' +
                                ' WHERE  COD_INSTRUTOR = ' + cod_instrutor;

      adoquery_aux.open;
      edt_instrutor.Text := adoquery_aux.fieldbyname('NOME').AsString;
    end;
end;

procedure TForm_rel_aulas.btn_fecharClick(Sender: TObject);
begin
  close;
end;

end.
