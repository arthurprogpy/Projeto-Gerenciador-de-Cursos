unit Unit_turmas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, DB, ADODB;

type
  Tform_turmas = class(TForm)
    Panel1: TPanel;
    btn_excluir: TBitBtn;
    btn_novo: TBitBtn;
    btn_salvar: TBitBtn;
    btn_alterar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_fechar: TBitBtn;
    edt_cod: TEdit;
    Label1: TLabel;
    edt_valor: TEdit;
    Label2: TLabel;
    edt_curso: TEdit;
    Label3: TLabel;
    edt_instrutor: TEdit;
    Label4: TLabel;
    adoquery_aux: TADOQuery;
    btn_curso: TBitBtn;
    btn_instrutor: TBitBtn;
    btn_localizar: TBitBtn;
    procedure btn_cursoClick(Sender: TObject);
    procedure btn_instrutorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure edt_valorEnter(Sender: TObject);
    procedure edt_valorExit(Sender: TObject);
    procedure btn_localizarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    operacao,pk, cod_curso, cod_instrutor: String;
    procedure desabilita_salvar(Sender: TObject);
    procedure habilita_salvar(Sender: TObject);
    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;

    function formata_valor(valor, destino :String) :String;
  end;

var
  form_turmas: Tform_turmas;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_Pesquisa_Turma, Unit_ConexaoDB;

{$R *.dfm}

{ Tform_turmas }

procedure Tform_turmas.bloqueia_campos;
var i: integer;
begin
  for i := 1 to form_turmas.ComponentCount -1 do
    begin
      if (form_turmas.Components[i] is TEdit) then
        begin
          (form_turmas.Components[i] as TEdit).Enabled := false;
          (form_turmas.Components[i] as TEdit).Color := clInfoBk;
        end;
    end;
end;

procedure Tform_turmas.desabilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := true;
  btn_salvar.Enabled := false;
  btn_alterar.Enabled := true;
  btn_cancelar.Enabled := false;
  btn_excluir.Enabled := true;

  btn_curso.Enabled := false;
  btn_instrutor.Enabled := false;

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

procedure Tform_turmas.habilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := false;
  btn_salvar.Enabled := true;
  btn_alterar.Enabled := false;
  btn_cancelar.Enabled := true;
  btn_excluir.Enabled := false;

  btn_curso.Enabled := true;
  btn_instrutor.Enabled := true;

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

procedure Tform_turmas.libera_campos;
var i: integer;
nome_obj: String;
begin
  for i:= 1 to form_turmas.ComponentCount -1 do
    begin
      if form_turmas.Components[i] is TEdit then
        begin
          nome_obj := form_turmas.Components[i].Name;
          if (nome_obj <> 'edt_curso') or (nome_obj <> 'edt_instrutor') then
            begin
            (form_turmas.Components[i] as TEdit).Enabled := true;
            (form_turmas.Components[i] as TEdit).color := clWindow ;

            edt_curso.Enabled := false;
            edt_instrutor.Enabled := false;

            edt_curso.color:= clInfoBk;
            edt_instrutor.Color := clInfoBk;
          end;
        end;
    end;
end;

procedure Tform_turmas.limpa_campos;
var i: integer;
begin
  for i:= 1 to form_turmas.ComponentCount -1 do
    begin
      if form_turmas.Components[i] is TEdit then
        begin
          (form_turmas.Components[i] as TEdit).Clear;
        end;
    end;
end;

procedure Tform_turmas.btn_cursoClick(Sender: TObject);
begin
  edt_curso.clear;
  sql_pesquisa := 'SELECT * FROM CURSOS ';
  form_pesquisa.ShowModal;
  if chave <> '' then
     begin
      cod_curso := chave;
      adoquery_aux.SQL.Text := 'SELECT NOME FROM CURSOS ' +
                                ' WHERE COD_CURSO = ' + QuotedStr(cod_curso);
      adoquery_aux.Open;
      edt_curso.Text := adoquery_aux.Fieldbyname('NOME').AsString;
     end;
end;

procedure Tform_turmas.btn_instrutorClick(Sender: TObject);
begin
  edt_instrutor.Clear;
  sql_pesquisa := 'SELECT * FROM INSTRUTORES';
  form_pesquisa.ShowModal;
  if chave <> '' then
    begin
      cod_instrutor := chave;
      adoquery_aux.SQL.Text := ' SELECT NOME FROM INSTRUTORES '+
                                ' WHERE COD_INSTRUTOR = ' + cod_instrutor;
      adoquery_aux.Open;
      edt_instrutor.Text := adoquery_aux.fieldbyname('NOME').AsString;
    end;
end;

procedure Tform_turmas.FormShow(Sender: TObject);
begin
  pk := '';
  cod_curso := '';
  cod_instrutor := '';
  operacao := '';
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);
end;

procedure Tform_turmas.btn_novoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  pk := '';
  cod_curso := '';
  cod_instrutor := '' ;
  habilita_salvar(Sender);
end;

procedure Tform_turmas.btn_salvarClick(Sender: TObject);
var deuerro : boolean;
begin
    if (edt_cod.Text='') or (edt_valor.Text='') or
    (cod_curso='') or (cod_instrutor='') then
    begin
      Showmessage('Preencha todos os campos !');
    end
    else
    begin
    if operacao = 'novo' then
      adoquery_aux.SQL.Text := 'INSERT INTO TURMAS VALUES ' +
                                '('+ QuotedStr(edt_cod.Text) +
                                ','+ QuotedStr(cod_curso) +
                                ','+ cod_instrutor +
                                ','+ formata_valor(edt_valor.Text, 'B') + ')'
    else if operacao = 'alterar' then
      adoquery_aux.SQL.Text := 'UPDATE TURMAS SET '+
                                ' COD_TURMA ='+ QuotedStr(edt_cod.Text) +
                                ', COD_CURSO ='+ QuotedStr(cod_curso) +
                                ', COD_INSTRUTOR ='+ cod_instrutor +
                                ', VALOR_AULA ='+ formata_valor(edt_valor.Text, 'B') +
                                ' WHERE COD_TURMA = '+ QuotedStr(pk);
                                
      DataModule_ConexaoDb.ConexaoBD.BeginTrans;
      try
        ADOQuery_aux.ExecSQL;
        deuerro := false;
      except
        on E : Exception do
        begin
          deuerro := true;
          if Form_logon.ErroBD(E.Message,'PK_Turmas') = 'Sim' then
            ShowMessage('Turma já cadastrada!')
          else if Form_logon.ErroBD(E.Message,'FK_Turmas_Cursos') = 'Sim' then
            Showmessage('Curso inválido!')
          else if Form_logon.ErroBD(E.Message,'FK_Turmas_Instrutores') = 'Sim' then
            Showmessage('Instrutor inválido!')
          else if Form_logon.ErroBD(E.Message,'FK_Matriculas_Turmas') = 'Sim' then
            Showmessage('Existem alunos matriculados nesta turma!')
          else if Form_logon.ErroBD(E.Message,'FK_Aulas_Turmas') = 'Sim' then
            Showmessage('Existem aulas cadastradas para esta turma!')
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
        pk := edt_cod.Text;
        desabilita_salvar(sender);
        bloqueia_campos;
        end;
      end;
    end;

procedure Tform_turmas.btn_alterarClick(Sender: TObject);
begin
  if pk = '' then
    begin
      ShowMessage('Imposssivel Alterar');
    end
  else
    begin
      libera_campos;
      habilita_salvar(Sender);
    end;
end;

procedure Tform_turmas.btn_cancelarClick(Sender: TObject);
begin
  if operacao = 'novo' then
    begin
      limpa_campos;
    end;
    desabilita_salvar(Sender);
    bloqueia_campos;
end;

procedure Tform_turmas.btn_excluirClick(Sender: TObject);
var deuerro : boolean;
begin
  if pk = '' then
    Showmessage('Impossível excluir!')
  else
  begin
    adoquery_aux.SQL.Text := ' DELETE FROM TURMAS ' +
    ' WHERE COD_TURMA = ' + QuotedStr(pk);
    DataModule_ConexaoDb.ConexaoBD.BeginTrans;
    try
      ADOQuery_aux.ExecSQL;
      deuerro := false;
    except
    on E : Exception do
      begin
        deuerro := true;
      if Form_logon.ErroBD(E.Message,'FK_Matriculas_Turmas') = 'Sim' then
        Showmessage('Existem alunos matriculados nesta turma!')
      else if Form_logon.ErroBD(E.Message,'FK_Aulas_Turmas') = 'Sim' then
        Showmessage('Existem aulas cadastradas para esta turma!')
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
    pk := '';
    cod_curso := '';
    cod_instrutor := '';
    desabilita_salvar(sender);
    limpa_campos;
    bloqueia_campos;
end;
end;
end;

procedure Tform_turmas.btn_fecharClick(Sender: TObject);
begin
  close;
end;

function Tform_turmas.formata_valor(valor, destino: String): String;
var
  valor_formatado: String;
  i: integer;
begin
  if (valor = '') or (destino = '') then
    begin
      Result := '';
      exit;
    end;
    valor_formatado := valor;
    Delete(valor_formatado, pos('R', valor_formatado), 1);
    Delete(valor_formatado, pos('$', valor_formatado), 1);
    Delete(valor_formatado, pos('.', valor_formatado), 1);

    valor_formatado := Trim(valor_formatado);

    if destino = 'T' then
    begin
      Result := FormatCurr('R$ #, ##0.00', StrToCurr(valor_formatado))
    end
    else if destino = 'E' then
      begin
        Result := valor_formatado
      end
    else if destino = 'B' then
      begin
        for i := 1 to length(valor_formatado) do
          begin
            if valor_formatado[i] = ',' then
              valor_formatado[i] := '.';
          end;
          Result := valor_formatado;
      end

end;

procedure Tform_turmas.edt_valorEnter(Sender: TObject);
begin
  edt_valor.Text := formata_valor(edt_valor.Text, 'E');
  
end;

procedure Tform_turmas.edt_valorExit(Sender: TObject);
begin
  edt_valor.Text := formata_valor(edt_valor.Text, 'T'); 
end;

procedure Tform_turmas.btn_localizarClick(Sender: TObject);
var sql : string;
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(sender);
  Form_pesquisa_turmas.ShowModal;
    if Form_pesquisa_turmas.chave <> '' then
      begin
        pk := Form_pesquisa_turmas.chave;
        sql := 'SELECT TURMAS.COD_TURMA, TURMAS.VALOR_AULA, ' +
                ' CURSOS.NOME AS CURSO, CURSOS.COD_CURSO, ' +
                '  INSTRUTORES.NOME AS INSTRUTOR, INSTRUTORES.COD_INSTRUTOR ' +
                'FROM TURMAS ' +
                'INNER JOIN CURSOS '+
                ' ON TURMAS.COD_CURSO = CURSOS.COD_CURSO '+
                'INNER JOIN INSTRUTORES '+
                ' ON TURMAS.COD_INSTRUTOR = INSTRUTORES.COD_INSTRUTOR ' +
                ' WHERE TURMAS.COD_TURMA = ' + QuotedStr(pk);
  ADOQuery_aux.SQL.Text := sql;
  ADOQuery_aux.Open;

  edt_cod.Text := ADOQuery_aux.fieldbyname('COD_TURMA').AsString;
  edt_valor.Text := ADOQuery_aux.fieldbyname('VALOR_AULA').AsString;
  edt_valor.Text := formata_valor(edt_valor.Text,'T');
  edt_curso.Text := ADOQuery_aux.fieldbyname('CURSO').AsString;
  edt_instrutor.Text := ADOQuery_aux.fieldbyname('INSTRUTOR').AsString;
  cod_curso := ADOQuery_aux.fieldbyname('COD_CURSO').AsString;
  cod_instrutor := ADOQuery_aux.fieldbyname('COD_INSTRUTOR').AsString;
  
end;
end;

end.
