object Form_rel_alunos: TForm_rel_alunos
  Left = 573
  Top = 310
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Rela'#231#227'o de Alunos por Turma'
  ClientHeight = 130
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 30
    Height = 13
    Caption = 'Turma'
  end
  object edt_turma: TEdit
    Left = 32
    Top = 48
    Width = 177
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 0
  end
  object btn_turma: TBitBtn
    Left = 216
    Top = 48
    Width = 35
    Height = 25
    TabOrder = 1
    OnClick = btn_turmaClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333FF33333333FF333993333333300033377F3333333777333993333333
      300033F77FFF3333377739999993333333333777777F3333333F399999933333
      33003777777333333377333993333333330033377F3333333377333993333333
      3333333773333333333F333333333333330033333333F33333773333333C3333
      330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
      333333333337733333FF3333333C333330003333333733333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
  end
  object btn_ok: TBitBtn
    Left = 48
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = btn_okClick
    Kind = bkOK
  end
  object btn_fechar: TBitBtn
    Left = 152
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object adoquery_rel_alunos: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    Left = 88
  end
  object adoquery_aux: TADOQuery
    Parameters = <>
    Left = 232
    Top = 8
  end
  object rel_alunos: TRvProject
    Left = 8
  end
  object ds_rel_alunos: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_alunos
    Left = 48
  end
end