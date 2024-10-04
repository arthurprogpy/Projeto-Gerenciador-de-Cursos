unit Unit_Usuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, DB, ADODB;

type
  Tform_usuarios = class(TForm)
    btn_Novo: TBitBtn;
    btn_salvar: TBitBtn;
    btn_alterar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_excluir: TBitBtn;
    btn_fechar: TBitBtn;
    pln_bottom: TPanel;
    edt_usuario: TEdit;
    Label1: TLabel;
    edt_nome: TEdit;
    Nome: TLabel;
    edt_senha: TEdit;
    Label2: TLabel;
    adoquery_aux: TADOQuery;
    btn_localizar: TBitBtn;
    btn_permissoes: TBitBtn;
    procedure btn_NovoClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_localizarClick(Sender: TObject);
    procedure btn_permissoesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure desabilita_salvar(Sender: TObject);
    procedure habilita_salvar(Sender: TObject);

    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;
  end;

var
  form_usuarios: Tform_usuarios;
  operacao, pk: String;


implementation

uses Unit_Logon, Unit_Pesquisa, Unit_permissoes, Unit_ConexaoDB;

{$R *.dfm}

{ Tform_usuarios }

procedure Tform_usuarios.bloqueia_campos;
var
  i: integer;
begin
  for i := 1 to form_usuarios.ComponentCount -1 do
    begin
      if form_usuarios.Components[i] is TEdit then
        begin
          (form_usuarios.Components[i] as TEdit).Enabled := false;
          (form_usuarios.Components[i] as TEdit).Color := clInfoBk;
        end;
    end;
end;

procedure Tform_usuarios.libera_campos;
var
  i: integer;
begin
  for i := 1 to form_usuarios.ComponentCount -1 do
    begin
      if form_usuarios.Components[i] is TEdit then
        begin
          (form_usuarios.Components[i] as TEdit).Enabled := true;
          (form_usuarios.Components[i] as TEdit).Color := clWindow;
        end;
    end;
end;

procedure Tform_usuarios.limpa_campos;
var
  i: integer;
begin
  for i := 1 to form_usuarios.ComponentCount -1 do
    begin
      if form_usuarios.Components[i] is TEdit then
        begin
          (form_usuarios.Components[i] as TEdit).Clear;
        end;
    end;
end;

procedure Tform_usuarios.desabilita_salvar(Sender: TObject);
begin
  btn_Novo.Enabled := true;
  btn_salvar.Enabled := false;
  btn_alterar.Enabled := true;
  btn_cancelar.Enabled := false;
  btn_excluir.Enabled := true;

  if Sender = btn_Novo then
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


procedure Tform_usuarios.habilita_salvar(Sender: TObject);
begin
  btn_Novo.Enabled := false;
  btn_salvar.Enabled := true;
  btn_alterar.Enabled := false;
  btn_cancelar.Enabled := true;
  btn_excluir.Enabled :=  false;

  if Sender = btn_Novo then
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

procedure Tform_usuarios.btn_NovoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  pk := '';
  habilita_salvar(Sender);
end;

procedure TForm_usuarios.btn_salvarClick(Sender: TObject);
var
  deuerro : boolean;
  senha : string;
begin
    if (edt_usuario.Text='') or (edt_nome.Text='') or (edt_senha.Text='') then
      begin
        Showmessage('Preencha todos os campos !');
      end
    else
      adoquery_aux.Close;
      adoquery_aux.SQL.Text := ' SELECT USUARIO FROM USUARIOS '+
                               ' WHERE USUARIO = ' + QuotedStr(edt_nome.text);

      adoquery_aux.Open;

      if not adoquery_aux.IsEmpty then
        begin
          ShowMessage('Já existe Usuario com esse nome !');
          adoquery_aux.Close;
        end
      else
       begin
        adoquery_aux.Close;
        senha := Form_logon.criptografa(edt_senha.Text);

        if operacao = 'novo' then
          adoquery_aux.SQL.Text := 'INSERT INTO USUARIOS VALUES '+
                                  '('+ QuotedStr(edt_usuario.Text) +
                                  ','+ QuotedStr(edt_nome.Text) +
                                  ','+ QuotedStr(senha) + ')'

        else if operacao = 'alterar' then
        adoquery_aux.SQL.Text := 'UPDATE USUARIOS SET '+
                                  ' USUARIO ='+ QuotedStr(edt_usuario.Text) +
                                  ', NOME ='+ QuotedStr(edt_nome.Text) +
                                  ', SENHA'+ QuotedStr(senha) +
                                  ' WHERE USUARIO = '+ QuotedStr(pk);

        DataModule_ConexaoDb.ConexaoBD.BeginTrans;

       try
        adoquery_aux.ExecSQL;
        deuerro := false;
       except
        on E : Exception do
          begin
            deuerro := true;
              if Form_logon.erroBd(E.Message,'PK_Usuarios') = 'Sim' then
                ShowMessage('Usuário já cadastrado!')
              else if Form_logon.erroBd(E.Message,'FK_Permissoes_Usuarios') = 'Sim' then
                Showmessage('Existem permissões cadastradas para este usuário!')
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
      pk := edt_usuario.Text;
      desabilita_salvar(sender);
      bloqueia_campos;
      end;
    end;
end;


procedure Tform_usuarios.btn_alterarClick(Sender: TObject);
begin
  if pk = '' then
    begin
      ShowMessage('Impossivel alterar !');
    end
  else
    begin
      libera_campos;
      habilita_salvar(Sender);
    end;
end;

procedure Tform_usuarios.btn_fecharClick(Sender: TObject);
begin
  close;
end;

procedure Tform_usuarios.btn_cancelarClick(Sender: TObject);
begin
   if operacao = 'novo' then
      begin
        limpa_campos;
      end;
   desabilita_salvar(Sender);
    bloqueia_campos;
end;

procedure TForm_usuarios.btn_excluirClick(Sender: TObject);
var
  deuerro : boolean;
begin
  if pk = '' then
    Showmessage('Impossível excluir!')
  else
  begin

    adoquery_aux.SQL.Text :=  ' DELETE FROM PERMISSOES ' +
                              ' WHERE USUARIO = ' + QuotedStr(pk) +
                              ' DELETE FROM USUARIOS ' +
                              ' WHERE USUARIO = ' + QuotedStr(pk);

    DataModule_ConexaoDb.ConexaoBD.BeginTrans;
try
    adoquery_aux.ExecSQL;
    deuerro := false;
except
  on E : Exception do
  begin
    deuerro := true;
  if Form_logon.erroBd(E.Message,'FK_Permissoes_Usuarios') = 'Sim' then
    Showmessage('Existem permissões cadastradas para este usuário!')
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
      desabilita_salvar(sender);
      limpa_campos;
      bloqueia_campos;
    end;
end;
end;

procedure Tform_usuarios.FormShow(Sender: TObject);
begin
  if form_permissoes = nil then
    Application.CreateForm(Tform_permissoes, form_permissoes);
  pk := '';
  operacao := '';
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);
end;

procedure Tform_usuarios.btn_localizarClick(Sender: TObject);
var
senha: string;
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);

  sql_pesquisa := 'SELECT USUARIO, NOME FROM USUARIOS ';
  form_pesquisa.ShowModal;

  if chave <> '' then
    begin
      pk := chave;
      adoquery_aux.SQL.Text := ' SELECT * FROM USUARIOS WHERE  USUARIO = ' +
                                QuotedStr(pk);
                                
      adoquery_aux.open;
      edt_usuario.Text :=  adoquery_aux.fieldbyname('USUARIO').AsString;
      edt_nome.Text := adoquery_aux.fieldbyname('NOME').AsString;
      senha :=  adoquery_aux.fieldbyname('SENHA').AsString;
      edt_senha.Text := form_logon.descriptografa(senha);
    end;
end;
procedure Tform_usuarios.btn_permissoesClick(Sender: TObject);
begin
  if pk = '' then
    begin
      ShowMessage('Usuario Invalido !');
    end
  else
    begin
      bloqueia_campos;
      desabilita_salvar(sender);
      usuarioP := pk;
      form_permissoes.ShowModal;
    end;
end;

end.
