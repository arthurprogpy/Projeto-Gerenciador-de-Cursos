unit Unit_Pesquisa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGrids, StdCtrls, Buttons;

type
  Tform_pesquisa = class(TForm)
    edt_pesquisa: TEdit;
    Label1: TLabel;
    btn_pesquisa: TBitBtn;
    btn_limpar: TBitBtn;
    grid_pesquisa: TDBGrid;
    Selecionar: TBitBtn;
    btn_cancelar: TBitBtn;
    adoquery_pesquisa: TADOQuery;
    Ds_pesquisa: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure btn_pesquisaClick(Sender: TObject);
    procedure btn_limparClick(Sender: TObject);
    procedure SelecionarClick(Sender: TObject);
    procedure btn_cancelarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_pesquisa: Tform_pesquisa;

  chave: String;
  sql_pesquisa: String;
  chave_aux :String;
implementation

uses Unit_Logon, Unit_ConexaoDB;

{$R *.dfm}

procedure Tform_pesquisa.FormShow(Sender: TObject);
begin
  edt_pesquisa.Clear;
end;

procedure Tform_pesquisa.btn_pesquisaClick(Sender: TObject);
begin
  if edt_pesquisa.text = '' then
    ShowMessage('Digite nome ou parte do nome !')
  else if sql_pesquisa  = '' then
    ShowMessage('Impossivel Pesquisar !')
  else
    begin
      adoquery_pesquisa.close;
      adoquery_pesquisa.SQL.Text :=  sql_pesquisa + ' WHERE NOME LIKE ' +
                                              QuotedStr(edt_pesquisa.Text  + '%');

      adoquery_pesquisa.open;
    end;
end;

procedure Tform_pesquisa.btn_limparClick(Sender: TObject);
begin
  chave := '';
  edt_pesquisa.Clear;
  adoquery_pesquisa.Close;
end;

procedure Tform_pesquisa.SelecionarClick(Sender: TObject);
begin
  if adoquery_pesquisa.Active = false then
    begin
      ShowMessage('Impossivel Selecionar !');
    end
  else
    begin
      chave := adoquery_pesquisa.Fields.Fields[0].AsString;
      chave_aux := adoquery_pesquisa.Fields[1].AsString;
      adoquery_pesquisa.close;
      close;
    end;
end;

procedure Tform_pesquisa.btn_cancelarClick(Sender: TObject);
begin
  chave := '';
  adoquery_pesquisa.close;
  close;
end;

procedure Tform_pesquisa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN : SelecionarClick(Sender);
  end;
end;

end.
