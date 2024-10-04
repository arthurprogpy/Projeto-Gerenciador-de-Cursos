unit Unit_instrutores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Mask, DB, ADODB;

type
  TForm_instrutores = class(TForm)
    btn_novo: TBitBtn;
    btn_salvar: TBitBtn;
    btn_alterar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_excluir: TBitBtn;
    btn_fechar: TBitBtn;
    Panel1: TPanel;
    edt_cod: TEdit;
    edt_nome: TEdit;
    edt_idade: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    mask_telefone: TMaskEdit;
    rd_sexo: TRadioGroup;
    adoquery_aux: TADOQuery;
    btn_pesquisar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    operacao, pk: String;
    procedure desabilita_salvar(Sender : TObject);
    procedure habilita_salvar(Sender : TObject);
    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;
  end;

var
  Form_instrutores: TForm_instrutores;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

procedure TForm_instrutores.bloqueia_campos;
var i: integer;
begin
  for i := 1 to Form_instrutores.ComponentCount -1 do
    begin
      if (Form_instrutores.Components[i] is TEdit) then
        begin
          mask_telefone.Enabled := false;
          mask_telefone.Color := clInfoBk;

          rd_sexo.Enabled := false;
          rd_sexo.Color := clInfoBk;

          (Form_instrutores.Components[i] as TEdit).Enabled := false;
          (Form_instrutores.Components[i] as TEdit).color := clInfoBk;
        end;
    end;
end;

procedure TForm_instrutores.desabilita_salvar(Sender: TObject);
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
  else if Sender =  btn_excluir then
    operacao := 'excluir';
end;

procedure TForm_instrutores.habilita_salvar(Sender: TObject);
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
    operacao := 'excluir';
end;

procedure TForm_instrutores.libera_campos;
var i: integer;
begin
  for i := 1 to Form_instrutores.ComponentCount -1 do
    begin
      if (Form_instrutores.Components[i] is TEdit) then
        begin
          if (Form_instrutores.Components[i] as TEdit).Name <> 'edt_cod' then
            begin
              mask_telefone.Enabled := true;
              mask_telefone.Color := clWindow;

              rd_sexo.Enabled := true;
              rd_sexo.Color := clWindow;

              (Form_instrutores.Components[i] as TEdit).Enabled := true;
              (Form_instrutores.Components[i] as TEdit).color := clWindow;
            end;
        end;
    end;
end;

procedure TForm_instrutores.limpa_campos;
var i: integer;
begin
  for i := 1 to Form_instrutores.ComponentCount -1 do
    begin
      if (Form_instrutores.Components[i] is TEdit) then
        begin
        (Form_instrutores.Components[i] as TEdit).clear;

        rd_sexo.ItemIndex := -1;
        mask_telefone.clear;
        end;
    end;
end;

procedure TForm_instrutores.FormShow(Sender: TObject);
begin
  pk := '';
  operacao := '';
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);
end;

procedure TForm_instrutores.btn_novoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  pk := '';
  habilita_salvar(Sender);
end;

procedure TForm_instrutores.btn_salvarClick(Sender: TObject);
var deuerro : boolean;
begin
  if (edt_nome.Text='') or (edt_idade.Text='') or
    (mask_telefone.Text='') or (rd_sexo.ItemIndex= -1)
  then
    begin
     Showmessage('Preencha todos os campos !');
    end
  else
    begin
      if operacao = 'novo' then
        begin
          case rd_sexo.ItemIndex of
            0: adoquery_aux.SQL.Text := 'INSERT INTO INSTRUTORES ' +
                                      '(NOME, IDADE, TELEFONE, SEXO) VALUES '+
                                      '('+ QuotedStr(edt_nome.Text) +
                                      ','+ edt_idade.Text +
                                      ','+ QuotedStr(mask_telefone.Text) +
                                      ','+ QuotedStr('M') + ')';

            1: adoquery_aux.SQL.Text := 'INSERT INTO INSTRUTORES ' +
                                      '(NOME, IDADE, TELEFONE, SEXO) VALUES '+
                                      '('+ QuotedStr(edt_nome.Text) +
                                      ','+ edt_idade.Text +
                                      ','+ QuotedStr(mask_telefone.Text) +
                                      ','+ QuotedStr('F') + ')';
          end;
        end
 ////////////////////////////////////////////////////////////////////////////

      else if operacao = 'alterar' then
        begin
         case rd_sexo.ItemIndex of
          0 : adoquery_aux.SQL.Text := 'UPDATE INSTRUTORES SET '+
                                        ' NOME ='+ QuotedStr(edt_nome.Text) +
                                        ', IDADE ='+ edt_idade.Text +
                                        ', TELEFONE ='+ QuotedStr(mask_telefone.Text) +
                                        ', SEXO = '+ QuotedStr('M') +
                                        ' WHERE COD_INSTRUTOR = '+ pk;

          1 : adoquery_aux.SQL.Text := 'UPDATE INSTRUTORES SET '+
                                      ' NOME ='+ QuotedStr(edt_nome.Text) +
                                      ', IDADE ='+ edt_idade.Text +
                                      ', TELEFONE =' + QuotedStr(mask_telefone.Text) +
                                      ', SEXO = ' + QuotedStr('F')+
                                      ' WHERE COD_INSTRUTOR = '+ pk;
         end;
 end;

  DataModule_ConexaoDb.ConexaoBD.BeginTrans;

  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E : Exception do
  begin
    deuerro := true;

  if Form_logon.ErroBD(E.Message,'PK_Instrutores') = 'Sim' then
    ShowMessage('Instrutor já cadastrado!')

  else if Form_logon.ErroBD(E.Message,'FK_Turmas_Instrutores') = 'Sim' then
    Showmessage('Existem turmas cadastradas para este Instrutor!')

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

          if operacao = 'novo' then
            begin
              ADOQuery_aux.SQL.Text:= 'SELECT COD_INSTRUTOR FROM INSTRUTORES ' +
                                      'WHERE NOME = '+ QuotedStr(edt_nome.Text) +
                                      'AND IDADE ='+ edt_idade.Text +
                                      'AND TELEFONE ='+ QuotedStr(mask_telefone.Text);
                                     // 'AND SEXO ='+ QuotedStr(edt_sexo.Text);

              ADOQuery_aux.Open;
              pk := ADOQuery_aux.fieldbyname('COD_INSTRUTOR').AsString;
              ADOQuery_aux.Close;
            end;

    desabilita_salvar(sender);
    bloqueia_campos;
    edt_cod.Text := pk;

    end;
  end;
end;
procedure TForm_instrutores.btn_alterarClick(Sender: TObject);
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

procedure TForm_instrutores.btn_cancelarClick(Sender: TObject);
begin
  if operacao = 'novo' then
    begin
      limpa_campos;
    end;
    
    desabilita_salvar(Sender);
    bloqueia_campos;
end;

procedure TForm_instrutores.btn_excluirClick(Sender: TObject);
  var deuerro : boolean;
begin
    if pk = '' then
      Showmessage('Impossível excluir!')
    else
    begin
      adoquery_aux.SQL.Text := ' DELETE FROM INSTRUTORES ' +
      ' WHERE COD_INSTRUTOR = ' + pk;

      DataModule_ConexaoDb.ConexaoBD.BeginTrans;

      try
        ADOQuery_aux.ExecSQL;
        deuerro := false;
      except
        on E : Exception do
          begin
            deuerro := true;
                if Form_logon.ErroBD(E.Message,'FK_Turmas_Instrutores') = 'Sim' then
                  Showmessage('Existem turmas cadastradas para este instrutor!')
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

procedure TForm_instrutores.btn_fecharClick(Sender: TObject);
begin
  Close;
end;

procedure TForm_instrutores.btn_pesquisarClick(Sender: TObject);
var sexo: String;
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);

  sql_pesquisa := 'SELECT * FROM INSTRUTORES';
  form_pesquisa.ShowModal;
  if chave <> '' then
    begin
      pk := chave;
      adoquery_aux.sql.Text :=  'SELECT * FROM INSTRUTORES ' +
                                'WHERE COD_INSTRUTOR = ' + pk;

      adoquery_aux.open;
      edt_cod.text := adoquery_aux.fieldbyname('COD_INSTRUTOR').AsString;
      edt_nome.Text := adoquery_aux.fieldbyname('NOME').AsString;
      edt_idade.Text := adoquery_aux.fieldbyname('IDADE').AsString;
      mask_telefone.Text := adoquery_aux.fieldbyname('TELEFONE').AsString;
      sexo := adoquery_aux.fieldbyname('SEXO').AsString;
      
      if sexo = 'M' then
        begin
          rd_sexo.ItemIndex := 0;
        end
      else
        begin
          rd_sexo.ItemIndex := 1;
        end;
end;
end;


end.
