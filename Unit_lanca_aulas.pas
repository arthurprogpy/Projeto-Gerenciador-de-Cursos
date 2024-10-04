unit Unit_lanca_aulas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Buttons, ComCtrls;

type
  Tform_lanca_aulas = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dt_aula: TDateTimePicker;
    edt_turma: TEdit;
    btn_lancar: TBitBtn;
    btn_cancelar: TBitBtn;
    btn_turma: TBitBtn;
    adoquery_aux: TADOQuery;
    procedure btn_lancarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_turmaClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_lanca_aulas: Tform_lanca_aulas;

implementation

uses Unit_Logon, Unit_Pesquisa_Turma, Unit_Alunos, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_lanca_aulas.btn_lancarClick(Sender: TObject);
var data_aula : string;
deuerro : boolean;

begin
  if edt_turma.Text = '' then
    ShowMessage('Informe a turma!')
  else if dt_aula.Date > date then
    ShowMessage('Não é permitido lançar aulas antecipadamente !')
  else
  begin
    data_aula := FormatDateTime('mm/dd/yyyy',dt_aula.Date);
    ADOQuery_aux.SQL.Text := 'INSERT INTO AULAS VALUES '+
                        '('+ QuotedStr(edt_turma.Text) +
                        ','+ QuotedStr(data_aula) +
                        ','+ QuotedStr('N') + ')';

    DataModule_ConexaoDb.ConexaoBD.BeginTrans;

  try
    ADOQuery_aux.ExecSQL;
    deuerro := false;
  except
    on E: Exception do
    begin
      deuerro := true;
      if Form_logon.ErroBD(E.Message,'PK_Aulas') = 'Sim' then
        Showmessage('Aula já lançada!')
      else
        ShowMessage('Ocorreu o seguinte erro: ' + E.Message);
      end;
      end;
      if deuerro = true then
        DataModule_ConexaoDb.ConexaoBD.RollbackTrans
      else
      begin
       DataModule_ConexaoDb.ConexaoBD.CommitTrans;
        ShowMessage('Aula lançada com sucesso!');
        edt_turma.Clear;
        dt_aula.Date := Date;
end;
end;
end;

procedure Tform_lanca_aulas.FormShow(Sender: TObject);
begin
  edt_turma.Clear;
  dt_aula.Date := Date;
end;

procedure Tform_lanca_aulas.btn_turmaClick(Sender: TObject);
begin
  edt_turma.Clear;
  form_pesquisa_turmas.ShowModal;

  if form_pesquisa_turmas.chave  <>  '' then
    begin
      edt_turma.Text := form_pesquisa_turmas.chave;
    end;
end;

procedure Tform_lanca_aulas.btn_cancelarClick(Sender: TObject);
begin
  close;  
end;

end.
