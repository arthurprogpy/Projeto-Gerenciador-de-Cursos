object form_permissoes: Tform_permissoes
  Left = 528
  Top = 199
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Permiss'#245'es'
  ClientHeight = 272
  ClientWidth = 276
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
    Left = 8
    Top = 8
    Width = 96
    Height = 13
    Caption = 'Fun'#231#245'es do Sistema'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 53
    Height = 13
    Caption = 'Permiss'#245'es'
  end
  object cb_funcoes: TComboBox
    Left = 8
    Top = 24
    Width = 185
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnEnter = cb_funcoesEnter
  end
  object btn_inserir: TBitBtn
    Left = 200
    Top = 16
    Width = 49
    Height = 25
    Caption = '+'
    TabOrder = 1
    OnClick = btn_inserirClick
  end
  object btn_retirar: TBitBtn
    Left = 208
    Top = 232
    Width = 49
    Height = 25
    Caption = '-'
    TabOrder = 2
    OnClick = btn_retirarClick
  end
  object btn_fechar: TBitBtn
    Left = 96
    Top = 232
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = btn_fecharClick
    Kind = bkCancel
  end
  object grid_permissoes: TDBGrid
    Left = 8
    Top = 72
    Width = 257
    Height = 145
    DataSource = ds_permissoes
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object adoquery_permissoes: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    Parameters = <>
    Left = 208
    Top = 48
  end
  object adoquery_aux: TADOQuery
    Connection = DataModule_ConexaoDb.ConexaoBD
    Parameters = <>
    Left = 240
    Top = 48
  end
  object ds_permissoes: TDataSource
    DataSet = adoquery_permissoes
    Left = 160
    Top = 48
  end
end
