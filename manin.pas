// Copyright 2020, Kaj Mikkelsen
// This software is distributed under the GPL 3 license
// The full text of the license can be found in the aboutbox
// as well as in the file "Copying"
unit Manin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ActnList,
  StdCtrls,Printers, ExtCtrls;

type

  { TFMain }

  TFMain = class(TForm)
    AAfslut: TAction;
    Aabn: TAction;
    AAbout: TAction;
    AFejlOgWeb: TAction;
    APersonliste: TAction;
    AGedText: TAction;
    ActionList1: TActionList;
    Image1: TImage;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem7: TMenuItem;
    MGEdcomSomText: TMenuItem;
    N1: TMenuItem;
    MOpen: TMenuItem;
    MExit: TMenuItem;
    OD1: TOpenDialog;
    procedure AabnExecute(Sender: TObject);
    procedure AAboutExecute(Sender: TObject);
    procedure AAfslutExecute(Sender: TObject);
    procedure AFejlOgWebExecute(Sender: TObject);
    procedure APersonlisteExecute(Sender: TObject);
    procedure AGedTextExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  FMain: TFMain;

implementation

{$R *.lfm}
Uses
    MyLib,UGedText,upersonliste,UAbout,UMailOgWeb;

{ TFMain }

procedure TFMain.AAfslutExecute(Sender: TObject);
begin
  Application.terminate;
end;

procedure TFMain.AFejlOgWebExecute(Sender: TObject);
begin
  FMailOgWeb.ShowModal;
end;

procedure TFMain.APersonlisteExecute(Sender: TObject);
begin
  If Od1.FileName <> '' Then
  Begin
    FpersonListe.FileName := OD1.Filename;
    FPersonliste.DoIndles := True;
    Fpersonliste.Show;
  end
  else
    ShowMessage('Vælg gedcom fil først');

end;

procedure TFMain.AGedTextExecute(Sender: TObject);
begin
  If Od1.FileName <> '' Then
  Begin
    Ftext.Label1.Caption:= OD1.FileName;
    FText.Memo1.Lines.LoadFromFile(OD1.FileName);
    FText.Show;
  end
  else
    ShowMessage('Vælg gedcom fil først');
end;

procedure TFMain.FormCreate(Sender: TObject);
begin

  RestoreForm(FMain);
end;

procedure TFMain.FormDestroy(Sender: TObject);
begin
  SaveForm(FMain);
end;

procedure TFMain.AabnExecute(Sender: TObject);
begin
  If OD1.Execute Then
  Begin
    APersonliste.Execute;
  end;
end;

procedure TFMain.AAboutExecute(Sender: TObject);
begin
  FAbout.ShowModal;
end;

end.

