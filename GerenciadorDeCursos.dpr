program GerenciadorDeCursos;

uses
  Forms,
  Unit_Logon in 'Unit_Logon.pas' {form_logon},
  Unit_Menu in 'Unit_Menu.pas' {form_menu},
  Unit_splash in 'Unit_splash.pas' {form_splash},
  Unit_Usuarios in 'Unit_Usuarios.pas' {form_usuarios},
  Unit_Pesquisa in 'Unit_Pesquisa.pas' {form_pesquisa},
  Unit_permissoes in 'Unit_permissoes.pas' {form_permissoes},
  Unit_Cursos in 'Unit_Cursos.pas' {form_cursos},
  Unit_instrutores in 'Unit_instrutores.pas' {Form_instrutores},
  Unit_turmas in 'Unit_turmas.pas' {form_turmas},
  Unit_Pesquisa_Turma in 'Unit_Pesquisa_Turma.pas' {form_pesquisa_turmas},
  Unit_Alunos in 'Unit_Alunos.pas' {form_alunos},
  Unit_matriculas in 'Unit_matriculas.pas' {form_matricula},
  Unit_lanca_aulas in 'Unit_lanca_aulas.pas' {form_lanca_aulas},
  Unit_lanca_presenca in 'Unit_lanca_presenca.pas' {form_lanca_presenca},
  Unit_pag_instrutores in 'Unit_pag_instrutores.pas' {form_pag_instrutores},
  Unit_Relatorio in 'Unit_Relatorio.pas' {form_relatorios},
  Unit_rel_turmas in 'Unit_rel_turmas.pas' {Form_rel_turmas},
  Unit_rel_alunos in 'Unit_rel_alunos.pas' {Form_rel_alunos},
  Unit_rel_faltas in 'Unit_rel_faltas.pas' {Form_rel_faltas},
  Unit_rel_aulas in 'Unit_rel_aulas.pas' {Form_rel_aulas},
  Unit_lanca_presenca2 in 'Unit_lanca_presenca2.pas' {form_lanca_presenca2},
  Unit_ConexaoDB in 'Unit_ConexaoDB.pas' {DataModule_ConexaoDb: TDataModule};

{$R *.res}

begin
  Application.Initialize;

  form_splash := Tform_splash.Create(Application);
  form_splash.Show;
  form_splash.Update;

  Application.Title := 'Gerenciador de Cursos';
  Application.CreateForm(TDataModule_ConexaoDb, DataModule_ConexaoDb);
  Application.CreateForm(Tform_logon, form_logon);
  
  if form_logon.autenticacao = false then
    Application.Terminate;

  form_splash.Hide;
  form_splash.Destroy;

  Application.Run;
end.
