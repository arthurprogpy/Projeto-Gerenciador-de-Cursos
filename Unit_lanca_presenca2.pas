unit Unit_lanca_presenca2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  Tform_lanca_presenca2 = class(TForm)
    btn_cancelar: TBitBtn;
    Button1: TButton;
    procedure btn_cancelarClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  form_lanca_presenca2: Tform_lanca_presenca2;

implementation

{$R *.dfm}

procedure Tform_lanca_presenca2.btn_cancelarClick(Sender: TObject);
begin
  Close;
end;

procedure Tform_lanca_presenca2.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure Tform_lanca_presenca2.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
