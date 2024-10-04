unit Unit_Relatorio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RpCon, RpConDS, RpDefine, RpRave, DB, ADODB, StdCtrls, Buttons;

type
  Tform_relatorios = class(TForm)
    btn_rel_curso: TBitBtn;
    btn_rel_turmas: TBitBtn;
    btn_rel_alunos: TBitBtn;
    btn_rel_faltas: TBitBtn;
    btn_rel_aulas: TBitBtn;
    btn_fechar: TBitBtn;
    adoquery_rel_cursos: TADOQuery;
    rel_cursos: TRvProject;
    ds_rel_cursos: TRvDataSetConnection;
    procedure btn_rel_cursoClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_rel_turmasClick(Sender: TObject);
    procedure btn_rel_alunosClick(Sender: TObject);
    procedure btn_rel_faltasClick(Sender: TObject);
    procedure btn_rel_aulasClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_relatorios: Tform_relatorios;

implementation

uses Unit_Logon, Unit_rel_turmas, Unit_rel_alunos, Unit_rel_faltas,
  Unit_rel_aulas, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_relatorios.btn_rel_cursoClick(Sender: TObject);
begin
  adoquery_rel_cursos.open;
    if adoquery_rel_cursos.IsEmpty then
      begin
        ShowMessage('Não ha cursos cadastrados !');
      end
    else
      begin
        rel_cursos.ProjectFile := GetCurrentDir + '\rel_cursos.rav';
        rel_cursos.Execute;
      end;
  adoquery_rel_cursos.Close;
end;

procedure Tform_relatorios.btn_fecharClick(Sender: TObject);
begin
  close;
end;

procedure Tform_relatorios.btn_rel_turmasClick(Sender: TObject);
begin
  if Form_rel_turmas = nil then
    Application.CreateForm(TForm_rel_turmas, Form_rel_turmas);
   Form_rel_turmas.ShowModal;
end;

procedure Tform_relatorios.btn_rel_alunosClick(Sender: TObject);
begin
  if Form_rel_alunos = nil then
    Application.CreateForm(TForm_rel_alunos, Form_rel_alunos);
  Form_rel_alunos.ShowModal;
end;

procedure Tform_relatorios.btn_rel_faltasClick(Sender: TObject);
begin
  if Form_rel_faltas = nil then
    Application.CreateForm(TForm_rel_faltas, Form_rel_faltas);
   Form_rel_faltas.ShowModal;
end;

procedure Tform_relatorios.btn_rel_aulasClick(Sender: TObject);
begin
  if Form_rel_aulas = nil then
    Application.CreateForm(TForm_rel_aulas, Form_rel_aulas);
  Form_rel_aulas.ShowModal;
end;

end.
