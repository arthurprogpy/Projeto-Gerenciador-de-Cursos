object Form_rel_aulas: TForm_rel_aulas
  Left = 457
  Top = 245
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Relat'#243'rio Aulas por Instrutor'
  ClientHeight = 139
  ClientWidth = 300
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
    Left = 16
    Top = 32
    Width = 38
    Height = 13
    Caption = 'Instrutor'
  end
  object edt_instrutor: TEdit
    Left = 16
    Top = 48
    Width = 233
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 0
  end
  object btn_instrutores: TBitBtn
    Left = 256
    Top = 48
    Width = 33
    Height = 25
    TabOrder = 1
    OnClick = btn_instrutoresClick
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
    Left = 56
    Top = 96
    Width = 75
    Height = 25
    TabOrder = 2
    OnClick = btn_okClick
    Kind = bkOK
  end
  object btn_fechar: TBitBtn
    Left = 152
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object adoquery_rel_aulas: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT INSTRUTORES.COD_INSTRUTOR,'
      #9#9'INSTRUTORES.NOME,'
      #9#9'TURMAS.COD_TURMA,'
      #9#9'COUNT(AULAS.DATA)  AS AULAS'
      'FROM INSTRUTORES'
      'INNER JOIN TURMAS '
      #9'ON INSTRUTORES.COD_INSTRUTOR = TURMAS.COD_INSTRUTOR'
      'INNER JOIN AULAS '
      #9'ON TURMAS.COD_TURMA = AULAS.COD_TURMA'
      'GROUP BY INSTRUTORES.COD_INSTRUTOR,'
      'INSTRUTORES.NOME, TURMAS.COD_TURMA')
    Left = 88
  end
  object adoquery_aux: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    Parameters = <>
    Left = 248
    Top = 96
  end
  object rel_aulas: TRvProject
    Left = 16
  end
  object ds_rel_aulas: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_aulas
    Left = 56
  end
end
