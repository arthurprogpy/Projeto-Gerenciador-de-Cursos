unit Unit_Menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, StdCtrls, Buttons, DB, ADODB, ExtCtrls;

type
  Tform_menu = class(TForm)
    btn_cadcursos: TBitBtn;
    btn_cadinstrutores: TBitBtn;
    btn_cadturmas: TBitBtn;
    btn_cadalunos: TBitBtn;
    btn_matriculas: TBitBtn;
    btn_frequencias: TBitBtn;
    btn_aulas: TBitBtn;
    btn_paginstrutores: TBitBtn;
    btn_relatorios: TBitBtn;
    btn_controle: TBitBtn;
    btn_fechar: TBitBtn;
    adoquery_aux: TADOQuery;
    Panel1: TPanel;
    StatusBar: TStatusBar;
    Timer1: TTimer;
    btn_alterar: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure btn_controleClick(Sender: TObject);
    procedure btn_cadcursosClick(Sender: TObject);
    procedure btn_cadinstrutoresClick(Sender: TObject);
    procedure btn_cadturmasClick(Sender: TObject);
    procedure btn_cadalunosClick(Sender: TObject);
    procedure btn_matriculasClick(Sender: TObject);
    procedure btn_aulasClick(Sender: TObject);
    procedure btn_frequenciasClick(Sender: TObject);
    procedure btn_paginstrutoresClick(Sender: TObject);
    procedure btn_relatoriosClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_alterarClick(Sender: TObject);
    procedure btn_fecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure permissoes;
  end;

var
  form_menu: Tform_menu;
  data: string;
  hora: string;

implementation

uses Unit_Logon, Unit_splash, Unit_Usuarios, Unit_Cursos, Unit_instrutores,
  Unit_turmas, Unit_Alunos, Unit_matriculas, Unit_lanca_aulas,
  Unit_lanca_presenca, Unit_pag_instrutores, Unit_Relatorio,
  Unit_lanca_presenca2, Unit_ConexaoDB, Unit_Pesquisa, Unit_Pesquisa_Turma;

{$R *.dfm}


procedure Tform_menu.permissoes;
begin
    ADOQuery_aux.SQL.Text := ' SELECT COD_FUNCAO FROM PERMISSOES ' +
                          ' WHERE USUARIO = ' + QuotedStr(usuario_logado);
    ADOQuery_aux.Open;

  if ADOQuery_aux.Locate('COD_FUNCAO','CADCUR',[loCaseInsensitive]) then
    btn_cadcursos.Enabled := True
  else
    btn_cadcursos.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','CADINS',[loCaseInsensitive]) then
    btn_cadinstrutores.Enabled := True
  else
    btn_cadinstrutores.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','CADTUR',[loCaseInsensitive]) then
    btn_cadturmas.Enabled := True
  else
    btn_cadturmas.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','CADALU',[loCaseInsensitive]) then
    btn_cadalunos.Enabled := True
  else
    btn_cadalunos.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','CADMAT',[loCaseInsensitive]) then
    btn_matriculas.Enabled := True
  else
    btn_matriculas.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','LANAUL',[loCaseInsensitive]) then
    btn_aulas.Enabled := True
  else
    btn_aulas.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','LANFRE',[loCaseInsensitive]) then
    btn_frequencias.Enabled := True
  else            
    btn_frequencias.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','PAGINS',[loCaseInsensitive]) then
    btn_paginstrutores.Enabled := True
  else
    btn_paginstrutores.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','RELATO',[loCaseInsensitive]) then
    btn_relatorios.Enabled := True
  else
    btn_relatorios.Enabled := False;
  if ADOQuery_aux.Locate('COD_FUNCAO','CONTRO',[loCaseInsensitive]) then
    btn_controle.Enabled := True
  else
    btn_controle.Enabled := False;
    ADOQuery_aux.Close;
end;

procedure Tform_menu.FormShow(Sender: TObject);
begin
  permissoes;
  if form_pesquisa = nil then
    Application.CreateForm(Tform_pesquisa, form_pesquisa);

  if form_pesquisa_turmas = nil then
    Application.CreateForm(Tform_pesquisa_turmas, form_pesquisa_turmas);
end;

procedure Tform_menu.btn_controleClick(Sender: TObject);
begin
  if form_usuarios = nil then
    Application.CreateForm(Tform_usuarios, form_usuarios);

  form_usuarios.ShowModal;
end;

procedure Tform_menu.btn_cadcursosClick(Sender: TObject);
begin
 if form_cursos = nil then
  Application.CreateForm(Tform_cursos, form_cursos);

 form_cursos.ShowModal;
end;

procedure Tform_menu.btn_cadinstrutoresClick(Sender: TObject);
begin
  if Form_instrutores = nil then
    Application.CreateForm(TForm_instrutores, Form_instrutores);

  Form_instrutores.ShowModal;
end;

procedure Tform_menu.btn_cadturmasClick(Sender: TObject);
begin
  if form_turmas = nil then
    Application.CreateForm(Tform_turmas, form_turmas);

  form_turmas.ShowModal;
end;

procedure Tform_menu.btn_cadalunosClick(Sender: TObject);
begin
  if form_alunos = nil then
    Application.CreateForm(Tform_alunos, form_alunos);

  form_alunos.ShowModal;
end;

procedure Tform_menu.btn_matriculasClick(Sender: TObject);
begin
  if form_matricula = nil then
    Application.CreateForm(Tform_matricula, form_matricula);

  form_matricula.ShowModal;
end;

procedure Tform_menu.btn_aulasClick(Sender: TObject);
begin

  if form_lanca_aulas = nil then
    Application.CreateForm(Tform_lanca_aulas, form_lanca_aulas);

  form_lanca_aulas.ShowModal;
end;

procedure Tform_menu.btn_frequenciasClick(Sender: TObject);
begin
  if form_lanca_presenca = nil then
    Application.CreateForm(Tform_lanca_presenca, form_lanca_presenca);

  form_lanca_presenca.ShowModal;
end;

procedure Tform_menu.btn_paginstrutoresClick(Sender: TObject);
begin
  if form_pag_instrutores = nil then
    Application.CreateForm(Tform_pag_instrutores, form_pag_instrutores);

  form_pag_instrutores.ShowModal;
end;

procedure Tform_menu.btn_relatoriosClick(Sender: TObject);
begin
  if form_relatorios = nil then
    Application.CreateForm(Tform_relatorios, form_relatorios);

  form_relatorios.ShowModal;
end;

procedure Tform_menu.Timer1Timer(Sender: TObject);
begin
  data := DateToStr(date);
  hora := TimeToStr(time);

  form_menu.StatusBar.Panels[0].Text := usuario_logado;
  form_menu.StatusBar.Panels[1].Text := DateToStr(DATE);
  form_menu.StatusBar.Panels[2].Text := TimeToStr(TIME);
end;

procedure Tform_menu.btn_alterarClick(Sender: TObject);
begin
  form_logon.Show;
  Close;

  usuario_logado := '';
end;

procedure Tform_menu.btn_fecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.
