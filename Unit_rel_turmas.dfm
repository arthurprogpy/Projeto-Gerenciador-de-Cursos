object Form_rel_turmas: TForm_rel_turmas
  Left = 566
  Top = 293
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Rela'#231#227'o de Turmas por Curso'
  ClientHeight = 127
  ClientWidth = 359
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
    Top = 16
    Width = 27
    Height = 13
    Caption = 'Curso'
  end
  object edt_curso: TEdit
    Left = 32
    Top = 32
    Width = 273
    Height = 21
    Color = clInfoBk
    Enabled = False
    TabOrder = 0
  end
  object btn_ok: TBitBtn
    Left = 96
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btn_okClick
    Kind = bkYes
  end
  object btn_fechar: TBitBtn
    Left = 184
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 2
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object btn_curso: TBitBtn
    Left = 312
    Top = 32
    Width = 25
    Height = 25
    TabOrder = 3
    OnClick = btn_cursoClick
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
  object adoquery_rel_turmas: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 16
    Top = 72
    object adoquery_rel_turmasCURSO: TStringField
      FieldName = 'CURSO'
    end
    object adoquery_rel_turmasTURMA: TStringField
      FieldName = 'TURMA'
      Size = 9
    end
    object adoquery_rel_turmasINTRUTORES: TStringField
      FieldName = 'INTRUTORES'
      Size = 30
    end
  end
  object adoquery_aux: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    Parameters = <>
    Left = 48
    Top = 72
  end
  object rel_turmas: TRvProject
    Left = 272
    Top = 72
  end
  object ds_rel_turmas: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = adoquery_rel_turmas
    Left = 312
    Top = 72
  end
end
