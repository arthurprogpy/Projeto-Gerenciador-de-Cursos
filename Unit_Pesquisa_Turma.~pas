unit Unit_Pesquisa_Turma;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, StdCtrls, Buttons;

type
  Tform_pesquisa_turmas = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cb_campos: TComboBox;
    edt_texto: TEdit;
    btn_pesquisar: TBitBtn;
    btn_limpar: TBitBtn;
    ds_pesquisa_turma: TDataSource;
    adoquery_Pesquisa_Turma: TADOQuery;
    btn_cancelar: TBitBtn;
    grid_pesquisa_turma: TDBGrid;
    btn_selecionar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btn_pesquisarClick(Sender: TObject);
    procedure btn_limparClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure btn_selecionarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    chave : String;
  end;

var
  form_pesquisa_turmas: Tform_pesquisa_turmas;

implementation

uses Unit_Logon, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_pesquisa_turmas.FormShow(Sender: TObject);
begin
  chave := '';
  cb_campos.ItemIndex := -1;
  edt_texto.Clear;
  adoquery_Pesquisa_Turma.close;
end;

procedure Tform_pesquisa_turmas.btn_pesquisarClick(Sender: TObject);
  var condicao : string;
  sql : string;
begin
  condicao := '';
    if cb_campos.ItemIndex = 0 then
      begin
      condicao := ' WHERE TURMAS.COD_TURMA LIKE ' +
                  QuotedStr(edt_texto.Text + '%')
      end
    else if cb_campos.ItemIndex = 1 then
      condicao := ' WHERE CURSOS.NOME LIKE ' +
                    QuotedStr(edt_texto.Text + '%')
    else if cb_campos.ItemIndex = 2 then
      condicao := ' WHERE INSTRUTORES.NOME LIKE ' +
                      QuotedStr(edt_texto.Text + '%');
    if (condicao='') or (edt_texto.Text='') then
        Showmessage('Pesquisa inválida!')
  else
    begin
      sql := 'SELECT TURMAS.COD_TURMA, ' +
                ' CURSOS.NOME AS CURSO, ' +
                ' INSTRUTORES.NOME AS INSTRUTOR ' +
                'FROM TURMAS ' +
                'INNER JOIN CURSOS '+
                ' ON TURMAS.COD_CURSO = CURSOS.COD_CURSO '+
                'INNER JOIN INSTRUTORES '+
                ' ON TURMAS.COD_INSTRUTOR = INSTRUTORES.COD_INSTRUTOR ';
      ADOQuery_pesquisa_turma.Close;
      ADOQuery_pesquisa_turma.SQL.Text := sql + condicao;
      ADOQuery_pesquisa_turma.Open;
    end;
end;


procedure Tform_pesquisa_turmas.btn_limparClick(Sender: TObject);
begin
  chave := '';
  cb_campos.ItemIndex := -1;
  edt_texto.Clear;
  adoquery_Pesquisa_Turma.Close;
end;

procedure Tform_pesquisa_turmas.btn_cancelarClick(Sender: TObject);
begin
  chave := '';
  adoquery_Pesquisa_Turma.Close;
  adoquery_Pesquisa_Turma.Active := false;
  close;
end;

procedure Tform_pesquisa_turmas.btn_selecionarClick(Sender: TObject);
begin
    if adoquery_Pesquisa_Turma.Active = false then
    begin
      ShowMessage('Impossivel Selecionar !');
    end
    else
    begin
      chave := adoquery_Pesquisa_Turma.fieldbyname('COD_TURMA').AsString;
      adoquery_Pesquisa_Turma.close;
     Close;
    end;
end;

end.
