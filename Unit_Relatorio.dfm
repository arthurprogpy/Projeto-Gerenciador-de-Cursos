object form_relatorios: Tform_relatorios
  Left = 491
  Top = 247
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Relatorios'
  ClientHeight = 257
  ClientWidth = 221
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btn_rel_curso: TBitBtn
    Left = 24
    Top = 16
    Width = 169
    Height = 25
    Caption = 'Rela'#231#227'o Cursos'
    TabOrder = 0
    OnClick = btn_rel_cursoClick
  end
  object btn_rel_turmas: TBitBtn
    Left = 24
    Top = 56
    Width = 169
    Height = 25
    Caption = 'Rela'#231#227'o de Turmas por Curso'
    TabOrder = 1
    OnClick = btn_rel_turmasClick
  end
  object btn_rel_alunos: TBitBtn
    Left = 24
    Top = 96
    Width = 169
    Height = 25
    Caption = 'Rela'#231#227'o de Alunos por Turma'
    TabOrder = 2
    OnClick = btn_rel_alunosClick
  end
  object btn_rel_faltas: TBitBtn
    Left = 24
    Top = 136
    Width = 169
    Height = 25
    Caption = 'Relat'#243'rio de Faltas dos Alunos'
    TabOrder = 3
    OnClick = btn_rel_faltasClick
  end
  object btn_rel_aulas: TBitBtn
    Left = 24
    Top = 176
    Width = 169
    Height = 25
    Caption = 'Relat'#243'rio de Aulas por Instrutor'
    TabOrder = 4
    OnClick = btn_rel_aulasClick
  end
  object btn_fechar: TBitBtn
    Left = 64
    Top = 216
    Width = 83
    Height = 25
    Caption = 'Fechar'
    TabOrder = 5
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object adoquery_rel_cursos: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT *'
      'FROM CURSOS ORDER BY NOME')
    Left = 24
    Top = 208
  end
  object rel_cursos: TRvProject
    Left = 160
    Top = 208
  end
  object ds_rel_cursos: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_cursos
    Left = 192
    Top = 208
  end
end
