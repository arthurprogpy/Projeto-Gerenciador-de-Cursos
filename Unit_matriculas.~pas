unit Unit_matriculas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB;

type
  Tform_matricula = class(TForm)
    Panel1: TPanel;
    btn_excluir: TBitBtn;
    btn_novo: TBitBtn;
    btn_salvar: TBitBtn;
    btn_alterar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_fechar: TBitBtn;
    edt_aluno: TEdit;
    edt_turma: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    adoquery_aux: TADOQuery;
    btn_aluno: TBitBtn;
    btn_turma: TBitBtn;
    btn_localizar: TBitBtn;
    procedure btn_alunoClick(Sender: TObject);
    procedure btn_turmaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_localizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pk_aluno, pk_turma, operacao, cod_turma, cod_aluno : String;
    procedure desabilita_salvar(Sender : TObject);
    procedure habilita_salvar(Sender : TObject);
    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;
  end;

var
  form_matricula: Tform_matricula;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_Pesquisa_Turma, Unit_ConexaoDB;

{$R *.dfm}

{ Tform_matricula }

procedure Tform_matricula.bloqueia_campos;
var
i : integer;
begin
  for i := 1 to form_matricula.ComponentCount -1 do
    begin
      if form_matricula.Components[i] is TEdit then
        begin
          (form_matricula.Components[i] as TEdit).Enabled := false;
          (form_matricula.Components[i] as TEdit).color := clInfoBk;
        end;
    end;
end;

procedure Tform_matricula.desabilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := true;
  btn_salvar.Enabled := false;
  btn_alterar.Enabled := true;
  btn_cancelar.Enabled := false;
  btn_excluir.Enabled := true;

  btn_aluno.Enabled := false;
  btn_turma.Enabled := false;

  if Sender = btn_novo then
    operacao := 'novo'
  else if Sender = btn_salvar then
    operacao := 'salvar'
  else if Sender = btn_alterar then
    operacao := 'alterar'
  else if Sender = btn_cancelar then
    operacao := 'cancelar'
  else if Sender = btn_excluir then
    operacao := 'excluir';
end;

procedure Tform_matricula.habilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := false;
  btn_salvar.Enabled := true;
  btn_alterar.Enabled := false;
  btn_cancelar.Enabled := true;
  btn_excluir.Enabled := false;

  btn_aluno.Enabled := true;
  btn_turma.Enabled := true;

  if Sender = btn_novo then
    operacao := 'novo'
  else if Sender = btn_salvar then
    operacao := 'salvar'
  else if Sender = btn_alterar then
    operacao := 'alterar'
  else if Sender = btn_cancelar then
    operacao := 'cancelar'
  else if Sender = btn_excluir then
    operacao := 'excluir';
end;

procedure Tform_matricula.libera_campos;
var
i : integer;
nome_obj: string;
begin
  for i := 1 to form_matricula.ComponentCount -1 do
    begin
    if form_matricula.Components[i] is TEdit then
      begin
        nome_obj := (form_matricula.Components[i] as TEdit).Name;
          if (nome_obj <> 'edt_aluno') and (nome_obj <> 'edt_turma') then
            begin
              (form_matricula.Components[i] as TEdit).Enabled := true;
              (form_matricula.Components[i] as TEdit).color := clwindow;
            end;
        end;
    end;
end;

procedure Tform_matricula.limpa_campos;
var
i: integer;
begin
  for i := 1 to form_matricula.ComponentCount -1 do
    begin
      if form_matricula.Components[i] is TEdit then
        begin
          (form_matricula.Components[i] as TEdit).Clear;
        end;
    end;
end;

procedure Tform_matricula.btn_alunoClick(Sender: TObject);
begin
  edt_aluno.clear;
  sql_pesquisa := 'SELECT * FROM ALUNOS ';
  form_pesquisa.ShowModal;

  if chave  <> '' then
    begin
      cod_aluno := chave;
      adoquery_aux.sql.Text := ' SELECT NOME FROM ALUNOS ' +
                                ' WHERE COD_ALUNO = ' +cod_aluno;
      adoquery_aux.Open;
      edt_aluno.text :=  adoquery_aux.fieldbyname('NOME').AsString;
    end;
end;

procedure Tform_matricula.btn_turmaClick(Sender: TObject);
begin
  edt_turma.Clear;
  form_pesquisa_turmas.ShowModal;

  if form_pesquisa_turmas.chave <> '' then
    begin
      cod_turma := form_pesquisa_turmas.chave;
      edt_turma.text := cod_turma;
    end;
end;

procedure Tform_matricula.FormShow(Sender: TObject);
begin
  pk_aluno := '';
  pk_turma := '';
  cod_turma := '';
  cod_aluno := '';
  operacao := '';

  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);
end;

procedure Tform_matricula.btn_novoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  habilita_salvar(Sender);

  pk_aluno := '';
  pk_turma := '';
  cod_aluno := '';
  cod_turma := '';
end;

procedure Tform_matricula.btn_salvarClick(Sender: TObject);
var deuerro : boolean;
begin
  if (cod_aluno='') or (edt_turma.Text='') then
    begin
      Showmessage('Informe todos os campos !');
    end
  else
    begin
      if operacao = 'novo' then
        adoquery_aux.SQL.Text := 'INSERT INTO MATRICULAS VALUES ' +
                                '('+ QuotedStr(cod_turma) +
                                ','+ cod_aluno + ')'
                                
      else if operacao = 'alterar' then
        adoquery_aux.SQL.Text := 'UPDATE MATRICULAS SET '+
                                  ' COD_TURMA ='+ QuotedStr(cod_turma) +
                                  ' ,COD_ALUNO ='+ cod_aluno +
                                  ' WHERE COD_TURMA = '+ QuotedStr(pk_turma) +
                                  ' AND COD_ALUNO = '+ pk_aluno;

DataModule_ConexaoDb.ConexaoBD.BeginTrans;
  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E : Exception do
  begin
    deuerro := true;
      if Form_logon.ErroBD(E.Message,'PK_Matriculas') = 'Sim' then
        ShowMessage('Matrícula já cadastrada!')
      else if Form_logon.ErroBD(E.Message,'FK_Frequencias_Matriculas') = 'Sim' then
        Showmessage('Existem frequências lançadas para esta matrícula!')
      else
        ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
    end;
  end;
    if deuerro = true then
      begin
        DataModule_ConexaoDb.ConexaoBD.RollbackTrans;
      end
    else
      begin
        DataModule_ConexaoDb.ConexaoBD.CommitTrans;
        pk_turma := cod_turma;
        pk_aluno := cod_aluno;
        desabilita_salvar(sender);
        bloqueia_campos;
      end;
    end;
  end;
procedure Tform_matricula.btn_alterarClick(Sender: TObject);
begin
  if (pk_turma = '') or (pk_aluno = '') then
  begin
    ShowMessage('impossivel alterar !');
  end
  else
  begin
    libera_campos;
    habilita_salvar(Sender);
  end;
end;

procedure Tform_matricula.btn_cancelarClick(Sender: TObject);
begin
  if operacao = 'novo' then
    begin
      limpa_campos
    end;

  desabilita_salvar(Sender);
  bloqueia_campos;
end;

procedure Tform_matricula.btn_excluirClick(Sender: TObject);
var deuerro : boolean;
begin
  if (pk_turma = '') or (pk_aluno = '') then
    Showmessage('Impossível excluir!')
  else
  begin
    adoquery_aux.SQL.Text := ' DELETE FROM MATRICULAS ' +
                              ' WHERE COD_TURMA = ' + QuotedStr(pk_turma) +
                              ' AND COD_ALUNO = ' + cod_aluno;

  DataModule_ConexaoDb.ConexaoBD.BeginTrans;
  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E : Exception do
  begin
    deuerro := true;
  if Form_logon.ErroBD(E.Message,'FK_Frequencias_Matriculas') = 'Sim' then
    Showmessage('Existem frequências lançadas para esta matrícula!')
  else
    ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
    end;
  end;
  if deuerro = true then
    begin
      DataModule_ConexaoDb.ConexaoBD.RollbackTrans;
    end
  else
  begin
    DataModule_ConexaoDb.ConexaoBD.CommitTrans;
    pk_turma := '';
    pk_aluno := '';
    cod_turma := '';
    cod_aluno := '';
    desabilita_salvar(sender);
    limpa_campos;
    bloqueia_campos;
    end;
  end;
end;

procedure Tform_matricula.btn_fecharClick(Sender: TObject);
begin
  Close;
end;

procedure Tform_matricula.btn_localizarClick(Sender: TObject);
var
sql: String;
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);

  sql := ' SELECT MATRICULAS.COD_TURMA, '+
                  ' MATRICULAS.COD_ALUNO, '+
                  ' ALUNOS.NOME '+
                  ' FROM MATRICULAS ' +
                  ' INNER JOIN ALUNOS '+
                  ' ON MATRICULAS.COD_ALUNO = ALUNOS.COD_ALUNO';

  sql_pesquisa := sql;
  form_pesquisa.ShowModal;

  if chave <> '' then
    begin
      pk_turma := chave;
      pk_aluno := chave_aux;

      adoquery_aux.SQL.text := sql +
                                    ' WHERE COD_TURMA = ' + QuotedStr(pk_turma) +
                                    ' AND MATRICULAS.COD_ALUNOS = ' + pk_aluno;

      adoquery_aux.Open;
      edt_aluno.Text := adoquery_aux.fieldbyname('NOME').AsString;
      edt_turma.Text := pk_turma;

      cod_turma := pk_turma;
      cod_aluno := pk_aluno;
    end;
end;

end.
