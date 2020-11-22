// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"
unit UGedText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFText }

  TFText = class(TForm)
    ExitButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  FText: TFText;

implementation
 uses
   MyLib;
{$R *.lfm}

 { TFText }

 procedure TFText.FormCreate(Sender: TObject);
 begin
   RestoreForm(FText);
 end;

procedure TFText.ExitButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFText.FormDestroy(Sender: TObject);
begin
  SaveForm(FText);
end;

end.

