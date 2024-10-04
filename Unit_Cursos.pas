unit Unit_Cursos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, ADODB;

type
  Tform_cursos = class(TForm)
    btn_novo: TBitBtn;
    btn_alterar: TBitBtn;
    btn_excluir: TBitBtn;
    btn_salvar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_fechar: TBitBtn;
    pnl_botoes: TPanel;
    edt_cod: TEdit;
    edt_nome: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    adoquery_aux: TADOQuery;
    btn_localizar: TBitBtn;
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
    operacao, pk: string;
    procedure desabilita_salvar(Sender : TObject);
    procedure habilita_salvar(Sender : TObject);
    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;
  end;

var
  form_cursos: Tform_cursos;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

{ Tform_cursos }

procedure Tform_cursos.bloqueia_campos;
var
i: integer;
begin
  for i := 1 to form_cursos.ComponentCount -1 do
    begin
      if form_cursos.Components[i] is TEdit then
        begin
          (form_cursos.Components[i] as TEdit).Enabled := false;
          (form_cursos.Components[i] as TEdit).color := clInfoBk;
        end;
      end;
end;            

procedure Tform_cursos.desabilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := true;
  btn_salvar.Enabled := false;
  btn_alterar.Enabled := true;
  btn_cancelar.Enabled := false;
  btn_excluir.Enabled := true;

  if Sender = btn_novo then
    operacao := 'novo'
  else if Sender = btn_salvar then
    operacao := 'salvar'
  else if Sender = btn_alterar then
    operacao := 'alterar'
  else if Sender = btn_cancelar then
    operacao := 'cancelar'
  else if Sender = btn_excluir then
    operacao := 'excluir'
end;

procedure Tform_cursos.habilita_salvar(Sender: TObject);
begin
  btn_novo.Enabled := false;
  btn_salvar.Enabled := true;
  btn_alterar.Enabled := false;
  btn_cancelar.Enabled := true;
  btn_excluir.Enabled := false;

  if Sender = btn_novo then
    operacao := 'novo'
  else if Sender = btn_salvar then
    operacao := 'salvar'
  else if Sender = btn_alterar then
    operacao := 'alterar'
  else if Sender = btn_cancelar then
    operacao := 'cancelar'
  else if Sender = btn_excluir then
    operacao := 'excluir'
end;

procedure Tform_cursos.libera_campos;
var i: integer;
begin
  for i := 1 to form_cursos.ComponentCount -1 do
    begin
      if form_cursos.Components[i] is TEdit then
        begin
         (form_cursos.Components[i] as TEdit).Enabled := true;
         (form_cursos.Components[i] as TEdit).color := clWindow;
        end;
    end;
end;

procedure Tform_cursos.limpa_campos;
var i: integer;
begin
  for i := 1 to form_cursos.ComponentCount -1 do
    begin
      if form_cursos.Components[i] is TEdit then
        begin
        (form_cursos.Components[i] as TEdit).Clear;
        end;
    end;
end;

procedure Tform_cursos.FormShow(Sender: TObject);
begin
  pk := '';
  operacao := '';
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);
end;

procedure Tform_cursos.btn_novoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  pk := '';
  habilita_salvar(Sender);
end;

procedure Tform_cursos.btn_salvarClick(Sender: TObject);
var deuerro : boolean;
begin
  if (edt_cod.Text='') or (edt_nome.Text='') then
    begin
      Showmessage('Preencha todos os campos !');
    end
  else
    begin
      if operacao = 'novo' then
        begin
           adoquery_aux.SQL.Text := 'INSERT INTO CURSOS VALUES '+
          '('+ QuotedStr(edt_cod.Text) +
          ','+ QuotedStr(edt_nome.Text) + ')'
        end

     else if operacao = 'alterar' then
        adoquery_aux.SQL.Text := 'UPDATE CURSOS SET '+
        ' COD_CURSO = ' + QuotedStr(edt_cod.Text) +
        ', NOME = '+ QuotedStr(edt_nome.Text) +
        ' WHERE COD_CURSO = '+ QuotedStr(pk);


  DataModule_ConexaoDb.ConexaoBD.BeginTrans;

  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E : Exception do
      begin
        deuerro := true;
          if Form_logon.ErroBD(E.Message,'PK_Cursos') = 'Sim' then
            begin
              ShowMessage('Curso já cadastrado!')
            end
          else if Form_logon.ErroBD(E.Message,'FK_Turmas_Cursos') = 'Sim' then
            begin
              Showmessage('Existem turmas cadastradas para este curso!')
            end
          else
            begin
              ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
            end;
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

procedure Tform_cursos.btn_alterarClick(Sender: TObject);
begin

  if pk = '' then
    begin
      ShowMessage('Impossivel Alterar !');
    end
  else
    begin
      libera_campos;
      habilita_salvar(Sender);
    end;
end;

procedure Tform_cursos.btn_cancelarClick(Sender: TObject);
begin
  if operacao = 'novo' then
    begin
      limpa_campos;
     end;

   desabilita_salvar(Sender);
   bloqueia_campos;
end;

procedure Tform_cursos.btn_excluirClick(Sender: TObject);
var deuerro : boolean;
begin
  if pk = '' then
    begin
      Showmessage('Impossível excluir!')
    end
  else
    begin
      adoquery_aux.SQL.Text := ' DELETE FROM CURSOS ' +
      ' WHERE COD_CURSO = ' + QuotedStr(pk);
      DataModule_ConexaoDb.ConexaoBD.BeginTrans;
    try
      ADOQuery_aux.ExecSQL;
      deuerro := false;
    except
     on E : Exception do
     begin
      deuerro := true;
      if Form_logon.ErroBD(E.Message,'FK_Turmas_Cursos') = 'Sim' then
      begin
        Showmessage('Existem turmas cadastradas para este curso!')
      end
    else
      begin
        ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
      end;
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
    desabilita_salvar(sender);
    limpa_campos;
    bloqueia_campos;
    end;
    end;
end;

procedure Tform_cursos.btn_fecharClick(Sender: TObject);
begin
  close;
end;

procedure Tform_cursos.btn_localizarClick(Sender: TObject);
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);

  sql_pesquisa := 'SELECT COD_CURSO, NOME FROM CURSOS';
  form_pesquisa.ShowModal;
    if chave <> '' then
      begin
        pk := chave;
        adoquery_aux.SQL.Text := ' SELECT * FROM CURSOS ' +
                                  ' WHERE COD_CURSO = ' + QuotedStr(pk);

        adoquery_aux.Open;

         edt_cod.text := adoquery_aux.fieldbyname('COD_CURSO').AsString;
         edt_nome.Text := adoquery_aux.fieldbyname('NOME').AsString;
      end;
end;

end.
