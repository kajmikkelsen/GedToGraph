unit UMailOgWeb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFMailOgWeb }

  TFMailOgWeb = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  FMailOgWeb: TFMailOgWeb;

implementation
Uses
  MyLib;
{$R *.lfm}

{ TFMailOgWeb }

procedure TFMailOgWeb.FormCreate(Sender: TObject);
begin
  RestoreForm(FMailOgWeb);
end;

procedure TFMailOgWeb.FormDestroy(Sender: TObject);
begin
  SaveForm(FMailOgWeb);
end;

end.

