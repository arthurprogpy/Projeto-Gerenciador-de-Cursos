unit Unit_lanca_presenca;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  DB,
  ADODB,
  CheckLst;

type
  Tform_lanca_presenca = class(TForm)
    edt_turma: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    cb_aulas: TComboBox;
    btn_turma: TBitBtn;
    btn_listar: TBitBtn;
    btn_lancar: TBitBtn;
    ck_lista_alunos: TCheckListBox;
    adoquery_aux: TADOQuery;
    btn_cancelar: TBitBtn;
    procedure btn_turmaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_listarClick(Sender: TObject);
    procedure cb_aulasEnter(Sender: TObject);
    procedure btn_lancarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_lanca_presenca: Tform_lanca_presenca;

implementation

uses Unit_Pesquisa_Turma, Unit_Logon, Unit_ConexaoDB, Unit_Alunos;

{$R *.dfm}

procedure Tform_lanca_presenca.btn_turmaClick(Sender: TObject);
begin
  edt_turma.Clear;
  form_pesquisa_turmas.ShowModal;

  if form_pesquisa_turmas.chave <> '' then
    begin
      edt_turma.Text := form_pesquisa_turmas.chave;
    end;
end;

procedure Tform_lanca_presenca.FormShow(Sender: TObject);
begin
  edt_turma.clear;
  cb_aulas.Clear;
  ck_lista_alunos.clear;
end;

procedure Tform_lanca_presenca.btn_listarClick(Sender: TObject);
var aluno: string;
begin
  if (edt_turma.Text = '') or (cb_aulas.Text = '') then
    begin
      ShowMessage('Informações Invalidas !');
    end
  else
    begin
      adoquery_aux.SQL.Text := ' SELECT MATRICULAS.COD_ALUNO, ALUNOS.NOME '+
                                ' FROM MATRICULAS INNER JOIN ALUNOS '+
                                ' ON MATRICULAS.COD_ALUNO = ALUNOS.COD_ALUNO '+
                                ' WHERE COD_TURMA =  ' + QuotedStr(edt_turma.Text) +
                                ' ORDER BY ALUNOS.NOME';

      adoquery_aux.Open;
        if adoquery_aux.IsEmpty then
          begin
            ShowMessage('Não existem alunos matriculados nesta turma !');
          end
        else
          begin
            while not adoquery_aux.Eof do
              begin
                aluno := adoquery_aux.Fieldbyname('COD_ALUNO').AsString;
                aluno := stringofchar('0',3-Length(aluno)) + aluno;
                aluno := aluno + ' - ' + adoquery_aux.FieldByName('NOME').AsString;
                ck_lista_alunos.Items.Add(aluno);
                adoquery_aux.Next;
              end;
           end;
      adoquery_aux.close;
    end;
end;


procedure Tform_lanca_presenca.cb_aulasEnter(Sender: TObject);
var data : TDateTime;
begin
  cb_aulas.Clear;
  if edt_turma.Text = '' then
    ShowMessage('Selecione uma turma!')
  else
  begin
    //BUSCA AS AULAS SEM FREQUENCIA
    ADOQuery_aux.SQL.Text := 'SELECT DATA FROM AULAS '+
                              'WHERE COD_TURMA = ' +QuotedStr(edt_turma.Text)+
                              'AND DATA NOT IN ' +
                              '(SELECT DATA FROM FREQUENCIAS '+
                              ' WHERE COD_TURMA = '+QuotedStr(edt_turma.Text)+')'+
                              'ORDER BY DATA DESC';

  ADOQuery_aux.Open;

    if ADOQuery_aux.IsEmpty then
     begin
      ShowMessage('Não existem aulas desta turma para lançamento de frequência!');
     end
    else
      begin
        While not ADOQuery_aux.Eof do
          begin
            data := ADOQuery_aux.fieldbyname('DATA').AsDateTime;
            cb_aulas.Items.Add(FormatDateTime('dd/mm/yyyy',data));
            ADOQuery_aux.Next;
          end;
      end;
    ADOQuery_aux.Close;
    end;
end;

procedure Tform_lanca_presenca.btn_lancarClick(Sender: TObject);
var i : integer;
cod_aluno, presente, data : string;
deuerro : boolean;
begin
  DataModule_ConexaoDb.ConexaoBD.BeginTrans;
  try
  deuerro := false;
  data := FormatDateTime('mm/dd/yyyy',StrToDate(cb_aulas.Text));

  for i := 0 to ck_lista_alunos.Items.Count -1 do
    begin
      ck_lista_alunos.Selected[i] := true;
      cod_aluno := copy(ck_lista_alunos.Items.Strings[i],1,3);

      if ck_lista_alunos.Checked[i] then
        presente := 'S'
      else
        presente := 'N';
        ADOQuery_aux.SQL.Text := 'INSERT INTO FREQUENCIAS VALUES '+
                                  '('+ QuotedStr(edt_turma.Text) +
                                  ','+ cod_aluno +
                                  ','+ QuotedStr(data) +
                                  ','+ QuotedStr(presente) + ')';

        ADOQuery_aux.ExecSQL;
      end;
  except
  on E: Exception do
    begin
      deuerro := true;
      ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
    end;
  end;
  if deuerro = true then
    DataModule_ConexaoDb.ConexaoBD.RollbackTrans
  else
    begin
      DataModule_ConexaoDb.ConexaoBD.CommitTrans;
      ShowMessage('Lançamento efetuado com sucesso!');
      edt_turma.Clear;
      cb_aulas.Clear;
      ck_lista_alunos.Clear;
    end;
end;

procedure Tform_lanca_presenca.btn_cancelarClick(Sender: TObject);
begin
  close;
end;

end.

