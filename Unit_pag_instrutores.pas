unit Unit_pag_instrutores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, DB, ADODB, StdCtrls, Buttons;

type
  Tform_pag_instrutores = class(TForm)
    edt_instrutor: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cb_mes_ano: TComboBox;
    btn_instrutor: TBitBtn;
    adoquery_aux: TADOQuery;
    btn_gerar: TBitBtn;
    btn_fechar: TBitBtn;
    ADOQuery_demonstrativo: TADOQuery;
    rel_demonstrativo: TRvProject;
    ds_demonstrativo: TRvDataSetConnection;
    ADOQuery_demonstrativoCOD_INSTRUTOR: TAutoIncField;
    ADOQuery_demonstrativoNOME: TStringField;
    ADOQuery_demonstrativoCOD_TURMA: TStringField;
    ADOQuery_demonstrativoDATA: TDateTimeField;
    ADOQuery_demonstrativoVALOR_AULA: TBCDField;
    procedure FormShow(Sender: TObject);
    procedure btn_instrutorClick(Sender: TObject);
    procedure cb_mes_anoEnter(Sender: TObject);
    procedure btn_gerarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cod_instrutor : String;
  end;

var
  form_pag_instrutores: Tform_pag_instrutores;

implementation

uses Unit_Logon, Unit_Pesquisa, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_pag_instrutores.FormShow(Sender: TObject);
begin
  edt_instrutor.clear;
  cod_instrutor := '';
  cb_mes_ano.Clear;
end;

procedure Tform_pag_instrutores.btn_instrutorClick(Sender: TObject);
begin
  edt_instrutor.clear;
  cb_mes_ano.Clear;
  cod_instrutor := '';
  sql_pesquisa := 'SELECT * FROM INSTRUTORES';
  form_pesquisa.ShowModal;
  if chave <> '' then
    begin
      cod_instrutor := chave;
      adoquery_aux.SQL.Text := 'SELECT NOME FROM INSTRUTORES ' +
                                ' WHERE COD_INSTRUTOR = ' + cod_instrutor;

      adoquery_aux.open;
      edt_instrutor.Text := adoquery_aux.fieldbyname('NOME').AsString;
    end;
end;

procedure Tform_pag_instrutores.cb_mes_anoEnter(Sender: TObject);
var mes, ano: String;
begin
  cb_mes_ano.clear;
  if cod_instrutor = '' then
    begin
      ShowMessage('Selecione um Instrutor !');
    end
  else
    begin
      adoquery_aux.SQL.Text := ' SELECT DISTINCT ' +
                                ' MONTH(AULAS.DATA) AS MES ,' +
                                ' YEAR(AULAS.DATA) AS ANO  '+
                                ' FROM AULAS '+
                                ' INNER JOIN TURMAS '  +
                                ' ON AULAS.COD_TURMA = TURMAS.COD_TURMA ' +
                                ' WHERE TURMAS.COD_INSTRUTOR = ' + cod_instrutor +
                                ' AND  AULAS.PAGA = ' + QuotedStr('N') +
                                ' ORDER BY YEAR(AULAS.DATA), MONTH(AULAS.DATA)';
                                

      adoquery_aux.open;
        if adoquery_aux.IsEmpty then
          begin
            ShowMessage('Não existem aulas a serem pagas para este instrutor!');
          end
        else
          begin
            mes := adoquery_aux.fieldbyname('MES').AsString;
            mes := stringofchar('0', 2-Length(mes)) + mes;
            ano := adoquery_aux.fieldbyname('ANO').AsString;
            cb_mes_ano.Items.Add(mes+'/'+ano);
            adoquery_aux.Next;
          end;
    end;
    adoquery_aux.close;  
end;

procedure Tform_pag_instrutores.btn_gerarClick(Sender: TObject);
var mes,ano, sql : string;
  begin
    if (cod_instrutor='') or (cb_mes_ano.Text='') then
      Showmessage('Informações Inválidas!')
    else
    begin
      mes := copy(cb_mes_ano.Text,1,2);
      ano := copy(cb_mes_ano.Text,4,4);

      sql :=' SELECT INSTRUTORES.COD_INSTRUTOR, INSTRUTORES.NOME, '+
            ' AULAS.COD_TURMA, AULAS.DATA, TURMAS.VALOR_AULA '+
            ' FROM AULAS '+
            ' INNER JOIN TURMAS ON '+
            ' AULAS.COD_TURMA = TURMAS.COD_TURMA '+
            ' INNER JOIN INSTRUTORES ON '+
            ' TURMAS.COD_INSTRUTOR = INSTRUTORES.COD_INSTRUTOR '+
            ' WHERE TURMAS.COD_INSTRUTOR =' + cod_instrutor +
            ' AND MONTH(DATA) =' + mes +
            ' AND YEAR(DATA) = ' + ano +
            ' AND AULAS.PAGA = ' + QuotedStr('N') +
            ' ORDER BY TURMAS.COD_TURMA, AULAS.DATA ';

    ADOQuery_demonstrativo.Close;           
    ADOQuery_demonstrativo.SQL.Clear;
    ADOQuery_demonstrativo.SQL.Text := sql;
    ADOQuery_demonstrativo.Open;
    rel_demonstrativo.ProjectFile := GetCurrentDir + '\Demonstrativov2.rav';
    rel_demonstrativo.Execute;
    ADOQuery_demonstrativo.Close;


  if Application.MessageBox('Deseja quitar estas aulas ?',
                            'Quitar Aulas ?',
                              mb_yesno+mb_iconquestion) = idyes then
      begin
        sql := ' UPDATE AULAS SET AULAS.PAGA =' + QuotedStr('S') +
                ' FROM AULAS '+
                ' INNER JOIN TURMAS ON '+
                ' AULAS.COD_TURMA = TURMAS.COD_TURMA '+
                ' WHERE TURMAS.COD_INSTRUTOR = ' + cod_instrutor;

      DataModule_ConexaoDb.ConexaoBD.BeginTrans;
      ADOQuery_aux.SQL.Text := sql;
      ADOQuery_aux.ExecSQL;
      DataModule_ConexaoDb.ConexaoBD.CommitTrans;

      Showmessage('Aulas quitadas com sucesso!');
      cb_mes_ano.Clear;
      edt_instrutor.Clear;
      cod_instrutor := '';
      end;
    end;
    end;
procedure Tform_pag_instrutores.btn_fecharClick(Sender: TObject);
begin
  close;
end;

end.
