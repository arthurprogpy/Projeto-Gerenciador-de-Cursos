unit Unit_ConexaoDB;

interface

uses
  SysUtils, Classes, DB, ADODB;

type
  TDataModule_ConexaoDb = class(TDataModule)
    ConexaoBD: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule_ConexaoDb: TDataModule_ConexaoDb;

implementation

{$R *.dfm}

end.
