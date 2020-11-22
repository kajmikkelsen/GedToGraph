// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"

unit uabout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFAbout }

  TFAbout = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FAbout: TFAbout;

implementation

uses
  MyLib, LCLIntf ;

{$R *.lfm}

{ TFAbout }

procedure TFAbout.FormCreate(Sender: TObject);
begin
  RestoreForm(FAbout);
end;

procedure TFAbout.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFAbout.Button2Click(Sender: TObject);
Var
  Found:  Boolean;
begin
  found := OpenURL('https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=PA4WU79QCGZYJ&item_name=Open+source+development&currency_code=DKK');
end;

procedure TFAbout.FormDestroy(Sender: TObject);
begin
  SaveForm(FAbout);
end;

end.
