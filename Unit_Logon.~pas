unit Unit_Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, DB, ADODB, ExtCtrls, IdBaseComponent,
  IdComponent;
type
  Tform_logon = class(TForm)
    edt_usuario: TEdit;
    edt_senha: TEdit;
    btn_ok: TBitBtn;
    btn_sair: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    adoquery_aux: TADOQuery;
    adoquery_log: TADOQuery;
    procedure btn_okClick(Sender: TObject);
    procedure btn_sairClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function autenticacao : boolean;
    function validacao(usuario, senha: String) : boolean;
    function criptografa(texto :string) : String;
    function descriptografa(texto: string) : String;
    function erroBd(msg, texto: String) : String;
    function mac: string;
    function PegaNomePC: String;
    procedure logs(dataN, horaN, usuario, status, nomePC, motivo, macN: string);
  end;

var
  form_logon: Tform_logon;
  usuario_logado: String;
  senha_usuario: String;
  usuario: String;

implementation

uses Unit_Menu, Unit_splash, Unit_permissoes, Unit_ConexaoDB;

{$R *.dfm}

{ Tform_logon }

function Tform_logon.autenticacao: boolean;
begin
  DataModule_ConexaoDb.ConexaoBD.ConnectionString := 'Provider=SQLOLEDB.1;'  +
                                                      'Initial Catalog=Academico;' +
                                                      'Data Source=DESKTOP-L66KA8R';
  try
    DataModule_ConexaoDb.ConexaoBD.Open('admin_academico', '123');
    Result := true;

  except
    ShowMessage('Não foi possivel se Conectar ao Servidor !');
    Result := false;

  end;
end;

function Tform_logon.criptografa(texto: string): string;
var
  i :integer;
  cripto, cod_ascii : string;
begin
  cripto := '';

  for i := length(texto) downto 1 do
    begin
      cod_ascii :=  IntToStr(ord(texto[i]));
      cod_ascii := StringOfChar('0', 3-Length(cod_ascii)) + cod_ascii;
      cripto := cripto + cod_ascii;
    end;
  Result := cripto;
end;

function Tform_logon.descriptografa(texto: string): String;
var
  i, cod_ascii : integer;
  descripto: String;
begin
  i := length(texto) + 1;
  while i > 1 do
  begin
    i := i - 3;
    cod_ascii := StrToInt(copy(texto, i,3));
    descripto := descripto + chr(cod_ascii);
   end;
  Result := descripto;
end;

function Tform_logon.validacao(usuario, senha: String) : boolean;
begin
  form_logon.adoquery_aux.SQL.Text := 'SELECT SENHA FROM USUARIOS ' +
                                      'WHERE USUARIO = ' + QuotedStr(usuario);

  form_logon.adoquery_aux.Open;
  if form_logon.adoquery_aux.IsEmpty then
    begin
      ShowMessage('Usuario não cadastrado !');
      Result := false;
      logs(data, hora, edt_usuario.Text, 'BLOQUEADO', PegaNomePC, 'USUARIO NÃO CADASTRADO', mac);
    end
  else
    begin
      senha_usuario := form_logon.adoquery_aux.fieldbyname('SENHA').AsString;
      senha_usuario := form_logon.descriptografa(senha_usuario);

      if senha_usuario <> senha then
        begin
          ShowMessage('Senha não confere !');
          Result := false;
          logs(data, hora, edt_usuario.Text, 'BLOQUEADO', PegaNomePC, 'SENHA INCORRETA', mac);
        end
      else
        begin
          usuario_logado := usuario;
          usuario := edt_usuario.text;
          usuarioP := edt_usuario.text;
          Result := true;
        logs(data, hora, edt_usuario.Text, 'LIBERADO', PegaNomePC, 'ACESSO LIBERADO', mac);
        end;
    end;
    form_logon.adoquery_aux.Close;
end;

procedure Tform_logon.btn_okClick(Sender: TObject);
begin
  if form_logon.validacao(edt_usuario.Text, edt_senha.text) = true then
    begin
      form_logon.hide;

      if form_menu = nil then
        Application.CreateForm(Tform_menu, form_menu);
      form_menu.Show;
    end;
end;

procedure Tform_logon.btn_sairClick(Sender: TObject);
begin
  close;
end;

function Tform_logon.erroBd(msg, texto: String): String;
var
i, tam_msg, tam_texto : integer;
pedaco: String;
begin
  tam_msg := Length(msg);
  tam_texto := Length(texto);

  for i := 1 to tam_msg do
    begin
      pedaco := copy(msg, i, tam_texto);
      if pedaco = texto then
        begin
          Result := 'Sim';
          Break;
        end
      else
      Result := 'Não';
    end;
end;

procedure Tform_logon.logs(dataN, horaN, usuario, status, nomePC, motivo, macN: string);
begin
  adoquery_log.Close;
  macN := mac;
  adoquery_log.SQL.Text := ' INSERT INTO LOGS VALUES ' +
                            ' ( ' + QuotedStr(dataN) + ','+
                                  QuotedStr(horaN) + ','+
                                  QuotedStr(usuario) + ','+
                                  QuotedStr(status) + ','+
                                  QuotedStr(nomePC) + ','+
                                  QuotedStr(motivo) + ','+
                                  QuotedStr(macN) + ')';
  adoquery_log.ExecSQL;
  adoquery_log.Close;
end;

function Tform_logon.mac: string;
var
  Lib: Cardinal;
  Func: function(GUID: PGUID): Longint; stdcall;
  GUID1, GUID2: TGUID;
begin
  Result := '';
  Lib := LoadLibrary('rpcrt4.dll');
  if Lib <> 0 then
  begin
    @Func := GetProcAddress(Lib, 'UuidCreateSequential');
    if Assigned(Func) then
    begin
      if (Func(@GUID1) = 0) and
         (Func(@GUID2) = 0) and
         (GUID1.D4[2] = GUID2.D4[2]) and
         (GUID1.D4[3] = GUID2.D4[3]) and
         (GUID1.D4[4] = GUID2.D4[4]) and
         (GUID1.D4[5] = GUID2.D4[5]) and
         (GUID1.D4[6] = GUID2.D4[6]) and
         (GUID1.D4[7] = GUID2.D4[7]) then
      begin
        Result :=
          IntToHex(GUID1.D4[2], 2) + '-' +
          IntToHex(GUID1.D4[3], 2) + '-' +
          IntToHex(GUID1.D4[4], 2) + '-' +
          IntToHex(GUID1.D4[5], 2) + '-' +
          IntToHex(GUID1.D4[6], 2) + '-' +
          IntToHex(GUID1.D4[7], 2);
      end;
    end;
  end;
end;

function Tform_logon.PegaNomePC: String;
var
  buffer : array[0..255] of char;
  tamanhobuffer: DWORD;
begin
  tamanhobuffer := sizeof(buffer);
  if Windows.GetComputerName(Buffer, tamanhobuffer) then
    Result := Buffer
  else
    Result := 'Erro ao obter o nome do computador';
end;

end.
