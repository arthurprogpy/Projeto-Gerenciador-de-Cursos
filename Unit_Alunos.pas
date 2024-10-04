unit Unit_Alunos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, Buttons, DB, ADODB;

type
  Tform_alunos = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    btn_excluir: TBitBtn;
    btn_novo: TBitBtn;
    btn_salvar: TBitBtn;
    btn_alterar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_fechar: TBitBtn;
    edt_cod: TEdit;
    edt_nome: TEdit;
    edt_idade: TEdit;
    mask_telefone: TMaskEdit;
    rd_sexo: TRadioGroup;
    btn_pesquisar: TBitBtn;
    adoquery_aux: TADOQuery;
    procedure btn_salvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_novoClick(Sender: TObject);
    procedure btn_excluirClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    operacao, pk :String;
    procedure desabilita_salvar(Sender: TObject);
    procedure habilita_salvar(Sender: TObject);
    procedure bloqueia_campos;
    procedure libera_campos;
    procedure limpa_campos;
  end;

var
  form_alunos: Tform_alunos;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_alunos.bloqueia_campos;
var i : integer ;
begin
  for i := 1 to form_alunos.ComponentCount -1 do
    begin
      if form_alunos.Components[i] is TEdit then
        begin
          (form_alunos.Components[i] as TEdit).Enabled := false;
          (form_alunos.Components[i] as TEdit).Color := clInfoBk;

          rd_sexo.Enabled := false;
          rd_sexo.color := clInfoBk;

          mask_telefone.Enabled := false;
          mask_telefone.color := clInfoBk;
        end;
    end;
end;

procedure Tform_alunos.btn_salvarClick(Sender: TObject);
var deuerro : boolean;
begin
    if (edt_nome.Text='') or (edt_idade.Text='') or
        (mask_telefone.Text='') or (rd_sexo.ItemIndex = -1) then
      begin
        Showmessage('Preencha todos os campos !');
      end
    else
      begin
        if operacao = 'novo' then
          begin
           if rd_sexo.ItemIndex = 0 then
           begin
             adoquery_aux.SQL.Text := 'INSERT INTO ALUNOS ' +
                                  '(NOME, IDADE, TELEFONE, SEXO) VALUES '+
                                  '('+ QuotedStr(edt_nome.Text) +
                                  ','+ edt_idade.Text +
                                  ','+ QuotedStr(mask_telefone.Text) +
                                  ','+ QuotedStr('M') + ')';
           end
           else
           begin
             adoquery_aux.SQL.Text := 'INSERT INTO ALUNOS ' +
                                  '(NOME, IDADE, TELEFONE, SEXO) VALUES '+
                                  '('+ QuotedStr(edt_nome.Text) +
                                  ','+ edt_idade.Text +
                                  ','+ QuotedStr(mask_telefone.Text) +
                                  ','+ QuotedStr('F') + ')';
           end;
        end
    else if operacao = 'alterar' then
      begin
        if rd_sexo.ItemIndex = 0 then
          begin
           adoquery_aux.SQL.Text := 'UPDATE ALUNOS SET '+
                                        ' NOME ='+ QuotedStr(edt_nome.Text) +
                                        ', IDADE ='+ edt_idade.Text+
                                        ', TELEFONE ='+ QuotedStr(mask_telefone.Text) +
                                        ', SEXO ='+ QuotedStr('M') +
                                        ' WHERE COD_ALUNO = '+ pk;
          end
          else
            begin
               adoquery_aux.SQL.Text := 'UPDATE ALUNOS SET '+
                                        ' NOME ='+ QuotedStr(edt_nome.Text) +
                                        ', IDADE ='+ edt_idade.Text +
                                        ', TELEFONE ='+ QuotedStr(mask_telefone.Text) +
                                        ', SEXO ='+ QuotedStr('F') +
                                        ' WHERE COD_ALUNO = '+ pk;
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
    if Form_logon.ErroBD(E.Message,'PK_Alunos') = 'Sim' then
      ShowMessage('Aluno já cadastrado!')
    else if Form_logon.ErroBD(E.Message,'FK_Matriculas_Alunos') = 'Sim' then
      Showmessage('Existem matrículas cadastradas para este aluno!')
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
          ADOQuery_aux.SQL.Text:='SELECT COD_ALUNO FROM ALUNOS ' +
                                  'WHERE NOME = '+ QuotedStr(edt_nome.Text) +
                                  ' AND IDADE ='+ edt_idade.Text +
                                  ' AND TELEFONE ='+ QuotedStr(mask_telefone.Text);
                                //  'AND SEXO ='+ QuotedStr(edt_sexo.Text);

      ADOQuery_aux.Open;
      pk := ADOQuery_aux.fieldbyname('COD_ALUNO').AsString;
      ADOQuery_aux.Close;
    end;
    desabilita_salvar(sender);
    bloqueia_campos;
    edt_cod.Text := pk;
      end;
    end;
    end;
procedure Tform_alunos.desabilita_salvar(Sender: TObject);
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
    operacao := 'excluir';
end;

procedure Tform_alunos.habilita_salvar(Sender: TObject);
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

procedure Tform_alunos.libera_campos;
var
i : integer;
begin
  for i := 1 to form_alunos.ComponentCount -1 do
    begin
      if form_alunos.Components[i] is TEdit then
        begin
          (form_alunos.Components[i] as TEdit).Enabled := true;
          (form_alunos.Components[i] as TEdit).Color := clWindow;

          rd_sexo.Enabled := true;
          rd_sexo.color := clWindow;

          mask_telefone.Enabled := true;
          mask_telefone.color := clWindow;

          edt_cod.Enabled := false;
          edt_cod.Color := clInfoBk;
        end;
    end;
end;

procedure Tform_alunos.limpa_campos;
var i: integer;
begin
  for i := 1 to form_alunos.ComponentCount -1 do
    begin
      if form_alunos.Components[i] is TEdit then
        begin
          (form_alunos.Components[i] as TEdit).Clear;
          rd_sexo.ItemIndex := -1;
          mask_telefone.clear;
        end;
    end;
end;


procedure Tform_alunos.FormShow(Sender: TObject);
begin
  pk := '';
  operacao := '';
  bloqueia_campos;
  limpa_campos;
  desabilita_salvar(Sender);
end;

procedure Tform_alunos.btn_novoClick(Sender: TObject);
begin
  libera_campos;
  limpa_campos;
  pk := '';
  habilita_salvar(Sender);
end;

procedure Tform_alunos.btn_excluirClick(Sender: TObject);
var deuerro : boolean;
begin
if pk = '' then
  Showmessage('Impossível excluir!')
else
begin
  adoquery_aux.SQL.Text := ' DELETE FROM ALUNOS ' +
                            ' WHERE COD_ALUNO = ' + pk;
DataModule_ConexaoDb.ConexaoBD.BeginTrans;
  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E : Exception do
  begin
    deuerro := true;
    if Form_logon.ErroBD(E.Message,'FK_Matriculas_Alunos') = 'Sim' then
      Showmessage('Existem matrículas cadastradas para este aluno!')
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

procedure Tform_alunos.btn_fecharClick(Sender: TObject);
begin
  close;
end;

procedure Tform_alunos.btn_pesquisarClick(Sender: TObject);
var sexo: String;
begin
  limpa_campos;
  bloqueia_campos;
  desabilita_salvar(Sender);

  sql_pesquisa := 'SELECT * FROM ALUNOS';
  form_pesquisa.ShowModal;
    if chave <> '' then
      begin
        pk := chave;
        adoquery_aux.SQL.Text := 'SELECT * FROM ALUNOS '+
                                  ' WHERE COD_ALUNO = ' + pk;
        adoquery_aux.Open;
        edt_cod.Text := adoquery_aux.fieldbyname('COD_ALUNO').AsString;
        edt_nome.text := adoquery_aux.fieldbyname('NOME').AsString;
        edt_idade.Text := adoquery_aux.fieldbyname('IDADE').AsString;
        mask_telefone.Text := adoquery_aux.fieldbyname('TELEFONE').AsString;

        sexo := adoquery_aux.fieldbyname('SEXO').AsString;
        if  sexo = 'M' then
          begin
            rd_sexo.ItemIndex := 0;
          end
        else
          begin
            rd_sexo.ItemIndex := 1;
          end;
     end;
     end;
procedure Tform_alunos.btn_alterarClick(Sender: TObject);
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

procedure Tform_alunos.btn_cancelarClick(Sender: TObject);
begin
    if operacao = 'novo' then
    begin
      limpa_campos;
    end;
    
    desabilita_salvar(Sender);
    bloqueia_campos;
end;

end.
