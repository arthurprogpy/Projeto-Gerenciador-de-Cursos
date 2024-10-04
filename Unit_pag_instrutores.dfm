object form_pag_instrutores: Tform_pag_instrutores
  Left = 484
  Top = 212
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pagamentos dos Instrutores'
  ClientHeight = 128
  ClientWidth = 532
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
    Top = 16
    Width = 38
    Height = 13
    Caption = 'Instrutor'
  end
  object Label2: TLabel
    Left = 344
    Top = 16
    Width = 44
    Height = 13
    Caption = 'M'#234's/Ano'
  end
  object edt_instrutor: TEdit
    Left = 16
    Top = 32
    Width = 281
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 0
  end
  object cb_mes_ano: TComboBox
    Left = 344
    Top = 32
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnEnter = cb_mes_anoEnter
  end
  object btn_instrutor: TBitBtn
    Left = 304
    Top = 24
    Width = 33
    Height = 25
    TabOrder = 2
    OnClick = btn_instrutorClick
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
  object btn_gerar: TBitBtn
    Left = 128
    Top = 96
    Width = 121
    Height = 25
    Caption = 'Gerar Demonstrativo'
    TabOrder = 3
    OnClick = btn_gerarClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
      00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
      8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
      8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
      8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
      03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
      03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
      33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
      33333337FFFF7733333333300000033333333337777773333333}
    NumGlyphs = 2
  end
  object btn_fechar: TBitBtn
    Left = 272
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object adoquery_aux: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    Parameters = <>
    Left = 32
    Top = 88
  end
  object ADOQuery_demonstrativo: TADOQuery
    AutoCalcFields = False
    Connection = DataModule_ConexaoDb.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      
        ' SELECT INSTRUTORES.COD_INSTRUTOR, INSTRUTORES.NOME,  AULAS.COD_' +
        'TURMA, AULAS.DATA, TURMAS.VALOR_AULA  FROM AULAS  INNER JOIN TUR' +
        'MAS ON  AULAS.COD_TURMA = TURMAS.COD_TURMA  INNER JOIN INSTRUTOR' +
        'ES ON  TURMAS.COD_INSTRUTOR = INSTRUTORES.COD_INSTRUTOR  WHERE T' +
        'URMAS.COD_INSTRUTOR =1 AND MONTH(DATA) =09 AND YEAR(DATA) = 2024' +
        ' AND AULAS.PAGA = '#39'N'#39' ORDER BY TURMAS.COD_TURMA, AULAS.DATA ')
    Left = 376
    Top = 88
    object ADOQuery_demonstrativoCOD_INSTRUTOR: TAutoIncField
      FieldName = 'COD_INSTRUTOR'
      ReadOnly = True
    end
    object ADOQuery_demonstrativoNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object ADOQuery_demonstrativoCOD_TURMA: TStringField
      FieldName = 'COD_TURMA'
      Size = 9
    end
    object ADOQuery_demonstrativoDATA: TDateTimeField
      FieldName = 'DATA'
    end
    object ADOQuery_demonstrativoVALOR_AULA: TBCDField
      FieldName = 'VALOR_AULA'
      Precision = 19
    end
  end
  object rel_demonstrativo: TRvProject
    Left = 424
    Top = 88
  end
  object ds_demonstrativo: TRvDataSetConnection
    LocalFilter = False
    RuntimeVisibility = rtEndUser
    DataSet = ADOQuery_demonstrativo
    Left = 464
    Top = 88
  end
end
