
unit Unit_permissoes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, StdCtrls, Buttons;

type
  Tform_permissoes = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cb_funcoes: TComboBox;
    btn_inserir: TBitBtn;
    btn_retirar: TBitBtn;
    btn_fechar: TBitBtn;
    adoquery_permissoes: TADOQuery;
    adoquery_aux: TADOQuery;
    ds_permissoes: TDataSource;
    grid_permissoes: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure cb_funcoesEnter(Sender: TObject);
    procedure btn_inserirClick(Sender: TObject);
    procedure btn_retirarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_permissoes: Tform_permissoes;
  usuarioP :String;

implementation

uses Unit_Logon, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_permissoes.FormShow(Sender: TObject);
begin

  adoquery_permissoes.SQL.Text := ' SELECT FUNCOES.NOME '                   +
                                  ' FROM FUNCOES INNER JOIN PERMISSOES ON ' +
                                  ' FUNCOES.COD_FUNCAO = PERMISSOES.COD_FUNCAO '+
                                  ' WHERE PERMISSOES.USUARIO = ' + QuotedStr(usuarioP) +
                                  ' ORDER BY FUNCOES.NOME';
  adoquery_permissoes.Open;                                  
end;

procedure Tform_permissoes.cb_funcoesEnter(Sender: TObject);
begin
  cb_funcoes.Clear;
  adoquery_aux.SQL.Text := 'SELECT NOME FROM FUNCOES ' +
                            'WHERE COD_FUNCAO NOT IN ' +
                            '(SELECT COD_FUNCAO FROM PERMISSOES ' +
                            ' WHERE USUARIO = ' + QuotedStr(usuarioP) + ')' +
                            'ORDER BY NOME ';

  adoquery_aux.Open;

  while not adoquery_aux.Eof do
    begin
      cb_funcoes.Items.Add(adoquery_aux.fieldbyname('NOME').AsString);
      adoquery_aux.Next;
    end;
  adoquery_aux.Close;
end;

procedure Tform_permissoes.btn_inserirClick(Sender: TObject);
var cod_funcao: String;
begin
  adoquery_aux.SQL.Text := 'SELECT COD_FUNCAO FROM FUNCOES ' +
                            'WHERE NOME = ' + QuotedStr(cb_funcoes.Text);
  adoquery_aux.Open;
  cod_funcao := adoquery_aux.fieldbyname('COD_FUNCAO').AsString;
  adoquery_aux.Close;

  adoquery_aux.SQL.Text := ' INSERT INTO PERMISSOES VALUES ' +
                            '(' + QuotedStr(cod_funcao) +
                            ','  + QuotedStr(usuarioP) + ')';

   DataModule_ConexaoDb.ConexaoBD.BeginTrans;
   adoquery_aux.ExecSQL;
   DataModule_ConexaoDb.ConexaoBD.CommitTrans;

   adoquery_permissoes.Close;
   adoquery_permissoes.Open;
   cb_funcoes.clear;                          
end;

procedure Tform_permissoes.btn_retirarClick(Sender: TObject);
var
cod_funcao: String;
 nome :String;
begin
  nome := adoquery_permissoes.fieldbyname('NOME').AsString;
  adoquery_aux.SQL.Text := 'SELECT COD_FUNCAO FROM FUNCOES ' +
                            'WHERE NOME = ' + QuotedStr(nome);

  adoquery_aux.Open;
  cod_funcao := adoquery_aux.fieldbyname('COD_FUNCAO').AsString;
  adoquery_aux.close;

  adoquery_aux.SQL.Text := ' DELETE FROM PERMISSOES  ' +
                            ' WHERE COD_FUNCAO = ' + QuotedStr(cod_funcao) +
                            ' AND USUARIO = ' + QuotedStr(usuarioP);

  DataModule_ConexaoDb.ConexaoBD.BeginTrans;
  adoquery_aux.ExecSQL;
  DataModule_ConexaoDb.ConexaoBD.CommitTrans;

  adoquery_permissoes.Close;
  adoquery_permissoes.Open;
end;

procedure Tform_permissoes.btn_fecharClick(Sender: TObject);
begin
  close;
end;

end.
