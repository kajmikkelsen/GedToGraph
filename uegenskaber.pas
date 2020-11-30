unit UEgenskaber;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,MyLib;

type

  { TFEgenskaber }

  TFEgenskaber = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  FEgenskaber: TFEgenskaber;

implementation

{$R *.lfm}

{ TFEgenskaber }

procedure TFEgenskaber.FormCreate(Sender: TObject);
begin
  RestoreForm(FEgenskaber);
end;

procedure TFEgenskaber.FormDestroy(Sender: TObject);
begin
  SaveForm(FEgenSkaber);
end;

end.

